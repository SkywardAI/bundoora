#!/bin/bash
set -e  # Exit immediately if any command fails

# Ensure the script is run as root.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Please run with sudo or as root."
   exit 1
fi

echo "Downloading NVIDIA Container Toolkit GPG key..."
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --yes --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

echo "Downloading and configuring NVIDIA Container Toolkit repository list..."
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

apt-get update -y

apt-get install -y nvidia-container-toolkit

systemctl restart docker

docker pull nvidia/cuda:12.2.2-base-ubi8

docker run --rm --gpus all nvidia/cuda:12.2.2-base-ubi8 nvidia-smi
