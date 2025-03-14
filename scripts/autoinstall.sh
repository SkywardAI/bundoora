#!/bin/bash

# Remove this line it will cause issue due to the execution mode.
# set -e # Exit immediately if nay command fails

# Update package list and remove any old Docker versions
apt-get update -y
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  apt-get remove -y $pkg
done

# Install prerequisite packages
apt-get install -y ca-certificates curl gnupg

# Add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker's APT repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again
apt-get update -y

# Install Docker packages
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create Docker group and add 'ubuntu' user to it
groupadd docker || true
usermod -aG docker "${SUDO_USER: -$(whoami)}"

# Apply new group membership
newgrp docker

echo -e "\n\e[1;33m==================== IMPORTANT ====================\e[0m"
echo -e "\e[1;33mPlease run 'newgrp docker' manually to apply your new group membership.\e[0m"
echo -e "\e[1;33m===================================================\e[0m\n"

