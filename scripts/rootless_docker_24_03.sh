#!/usr/bin/env bash
set -euo pipefail

echo "=== Rootless Docker installer for Ubuntu 24.04 (24.03 you mentioned) ==="

# ---- Basic checks ----
if [ "$EUID" -eq 0 ]; then
  echo "Please DO NOT run this script as root. Run it as a normal user who has sudo."
  exit 1
fi

USER_NAME="$(whoami)"
HOME_DIR="$HOME"

echo "Running as user: $USER_NAME"
echo "Home directory  : $HOME_DIR"
echo

# ---- Step 1: Install required packages (with sudo) ----
echo ">>> Installing required packages with sudo..."
sudo apt update
sudo apt install -y uidmap dbus-user-session slirp4netns fuse-overlayfs curl

echo
echo ">>> Packages installed."

# ---- Step 2: Add AppArmor profile to allow rootlesskit (Ubuntu 23.10+/24.04+) ----
APPARMOR_PROFILE="/etc/apparmor.d/home.${USER_NAME}.bin.rootlesskit"

echo
echo ">>> Configuring AppArmor profile for rootlesskit at:"
echo "    ${APPARMOR_PROFILE}"

sudo bash -c "cat > '${APPARMOR_PROFILE}'" <<EOT
# ref: https://ubuntu.com/blog/ubuntu-23-10-restricted-unprivileged-user-namespaces
abi <abi/4.0>,
include <tunables/global>

/home/${USER_NAME}/bin/rootlesskit flags=(unconfined) {
  userns,

  # Site-specific additions and overrides. See local/README for details.
  include if exists <local/home.${USER_NAME}.bin.rootlesskit>
}
EOT

echo ">>> Reloading AppArmor..."
sudo systemctl restart apparmor.service

# ---- Step 3: Install Docker (rootless) using official script ----
echo
echo ">>> Downloading and running Docker rootless install script..."
curl -fsSL https://get.docker.com/rootless | sh

# ---- Step 4: Configure environment variables ----
BASHRC="${HOME_DIR}/.bashrc"

echo
echo ">>> Ensuring PATH and DOCKER_HOST are set in ${BASHRC} ..."

if ! grep -q 'HOME/bin:$PATH' "${BASHRC}"; then
  echo 'export PATH=$HOME/bin:$PATH' >> "${BASHRC}"
  echo "Added PATH export to ${BASHRC}"
fi

if ! grep -q 'DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock' "${BASHRC}"; then
  echo 'export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock' >> "${BASHRC}"
  echo "Added DOCKER_HOST export to ${BASHRC}"
fi

# Apply changes for current shell
# shellcheck disable=SC1090
source "${BASHRC}"

# ---- Step 5: Start and enable rootless Docker service ----
echo
echo ">>> Starting user-level docker service..."
systemctl --user start docker || true
systemctl --user enable docker || true

echo
echo ">>> Enabling lingering so Docker keeps running after logout..."
sudo loginctl enable-linger "${USER_NAME}"

# ---- Step 6: Verify ----
echo
echo ">>> Checking docker binary and info..."
which docker || echo "WARNING: 'docker' not found in PATH"

echo
if docker info > /tmp/docker_info.txt 2>/tmp/docker_info_err.txt; then
  echo "docker info succeeded."
  if grep -q 'Rootless: true' /tmp/docker_info.txt; then
    echo ">>> Rootless mode detected: Rootless: true"
  else
    echo ">>> WARNING: 'Rootless: true' not found in docker info output."
    echo "    Check /tmp/docker_info.txt for details."
  fi
else
  echo ">>> docker info failed. Error output:"
  cat /tmp/docker_info_err.txt || true
fi

echo
echo ">>> Test run: docker run hello-world (this may pull an image)..."
if docker run --rm hello-world; then
  echo ">>> Rootless Docker appears to be working correctly 🎉"
else
  echo ">>> WARNING: 'docker run hello-world' failed. Check error above."
fi

echo
echo "=== Done. You may need to open a new terminal or 'source ~/.bashrc' ==="
