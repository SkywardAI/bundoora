#!/usr/bin/env bash
set -euo pipefail

echo "=== Rootful Docker + NVIDIA Container Toolkit installer (Ubuntu 24.xx LTS) ==="

# --------------------------------------------------------------------
# 0. Basic checks
# --------------------------------------------------------------------
if [[ "$EUID" -eq 0 ]]; then
  echo "Please DO NOT run this script as root."
  echo "Run it as a normal user who has sudo (e.g. 'race')."
  exit 1
fi

USER_NAME="$(whoami)"
HOME_DIR="$HOME"

echo "Running as user: $USER_NAME"
echo "Home directory : $HOME_DIR"
echo

# --------------------------------------------------------------------
# 1. Clean up previous rootless Docker (best-effort)
# --------------------------------------------------------------------
echo ">>> Cleaning up any existing rootless Docker setup (if present)..."

# Stop and disable user-level docker service (rootless)
systemctl --user stop docker 2>/dev/null || true
systemctl --user disable docker 2>/dev/null || true
systemctl --user daemon-reload 2>/dev/null || true

# Disable lingering for this user (no longer needed for rootless docker)
sudo loginctl disable-linger "$USER_NAME" 2>/dev/null || true

# Remove rootless docker-related binaries from ~/bin
rm -f "$HOME_DIR/bin/docker" \
      "$HOME_DIR/bin/dockerd-rootless-setuptool.sh" \
      "$HOME_DIR/bin/rootlesskit" \
      "$HOME_DIR/bin/rootlesskit-docker-proxy" 2>/dev/null || true

# Remove AppArmor profile for rootlesskit if we created it
sudo rm -f "/etc/apparmor.d/home.${USER_NAME}.bin.rootlesskit" 2>/dev/null || true
sudo systemctl restart apparmor.service || true

# Remove DOCKER_HOST overrides and PATH tweaks from shell configs
sed -i '/DOCKER_HOST=unix:\/\/\/run\/user\/$(id -u)\/docker.sock/d' "$HOME_DIR/.bashrc" 2>/dev/null || true
sed -i '/DOCKER_HOST=unix:\/\/\/run\/user\/$(id -u)\/docker.sock/d' "$HOME_DIR/.profile" 2>/dev/null || true
sed -i 's/^export PATH=$HOME\/bin:$PATH/# export PATH=$HOME\/bin:$PATH/' "$HOME_DIR/.bashrc" 2>/dev/null || true

unset DOCKER_HOST || true

# Remove old docker client config/contexts if they pointed to rootless
rm -rf "$HOME_DIR/.docker" 2>/dev/null || true

# Reload shell config (best-effort)
if [[ -f "$HOME_DIR/.bashrc" ]]; then
  # shellcheck disable=SC1090
  source "$HOME_DIR/.bashrc"
fi
hash -r

echo ">>> Rootless Docker cleanup done (if it existed)."
echo

# --------------------------------------------------------------------
# 2. Install Docker Engine (rootful) from official Docker repo
# --------------------------------------------------------------------
echo ">>> Installing Docker Engine (rootful)..."

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg

# Docker GPG key and repo
sudo install -m 0755 -d /etc/apt/keyrings
if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
fi

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y \
  docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker

echo ">>> Docker Engine installed and docker.service started."
echo

# Add current user to docker group
echo ">>> Adding user '$USER_NAME' to 'docker' group..."
sudo usermod -aG docker "$USER_NAME"
echo "   You may need to log out and log back in for group changes to take full effect."
echo

# --------------------------------------------------------------------
# 3. Install NVIDIA Container Toolkit
# --------------------------------------------------------------------
echo ">>> Installing NVIDIA Container Toolkit..."

# Check that nvidia-smi works on host (driver installed)
set +e
if command -v nvidia-smi >/dev/null 2>&1; then
  echo "nvidia-smi found on host:"
  nvidia-smi || echo "WARNING: nvidia-smi failed; driver may not be fully working."
else
  echo "WARNING: 'nvidia-smi' not found. NVIDIA driver may not be installed."
  echo "         This script will continue, but GPU containers may not work until driver is fixed."
fi
set -e

# Add NVIDIA repo key and list
sudo mkdir -p /usr/share/keyrings
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --yes --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -fsSL https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y nvidia-container-toolkit

echo ">>> Configuring Docker to use NVIDIA runtime..."
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

echo ">>> NVIDIA Container Toolkit installed and Docker reloaded."
echo

# --------------------------------------------------------------------
# 4. Quick verification
# --------------------------------------------------------------------
echo ">>> Verifying docker CLI and daemon..."

DOCKER_BIN="$(command -v docker || true)"
echo "docker binary : ${DOCKER_BIN:-not found}"
echo "DOCKER_HOST   : ${DOCKER_HOST:-<empty>}"
echo

set +e
docker version >/tmp/docker_version.txt 2>/tmp/docker_version_err.txt
if [[ $? -eq 0 ]]; then
  echo "docker version:"
  cat /tmp/docker_version.txt
else
  echo "WARNING: 'docker version' failed:"
  cat /tmp/docker_version_err.txt
fi
set -e

echo
echo ">>> Testing basic docker run (hello-world)..."
set +e
docker run --rm hello-world
if [[ $? -eq 0 ]]; then
  echo ">>> Basic docker run succeeded."
else
  echo "WARNING: 'docker run hello-world' failed. Check error above."
fi
set -e

echo
echo ">>> Testing GPU inside container (if available)..."
set +e
docker pull -q nvidia/cuda:12.2.2-base-ubuntu22.04
docker run --rm --gpus all nvidia/cuda:12.2.2-base-ubuntu22.04 nvidia-smi
GPU_TEST_RC=$?
if [[ $GPU_TEST_RC -eq 0 ]]; then
  echo ">>> GPU test inside container succeeded (nvidia-smi ran in container)."
else
  echo "WARNING: GPU test in container failed (exit code $GPU_TEST_RC)."
  echo "         If host nvidia-smi works, re-check NVIDIA driver + container toolkit setup."
fi
set -e

echo
echo "=== Done. Rootful Docker + NVIDIA Container Toolkit setup complete. ==="
echo "You may want to log out and log back in so 'docker' works without sudo."
