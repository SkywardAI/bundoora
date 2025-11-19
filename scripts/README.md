# Bundoora Installation Scripts

This repository contains shell scripts that automate the installation and configuration of NVIDIA GPU drivers, Docker rootless mode, and NVIDIA Container Toolkit on Ubuntu systems. These scripts simplify the setup process for GPU-accelerated applications and containerized workflows.

## Available Scripts

| Script | Description | Ubuntu Version |
|--------|-------------|----------------|
| `nvidia-gpu-driver.sh` | Install NVIDIA GPU drivers | All versions |
| `install_rootless_docker_22_04.sh` | Install Docker in rootless mode | Ubuntu 22.04 |
| `install_rootless_docker_24_03.sh` | Install Docker in rootless mode | Ubuntu 24.04+ |
| `nvidia-container-tool.sh` | Install NVIDIA Container Toolkit | All versions |

## Install NVIDIA GPU Driver

```bash
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/nvidia-gpu-driver.sh | sudo bash
```

**Note:** Reboot required after installation.

## Install Docker Rootless Mode

### Ubuntu 22.04

```bash
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/install_rootless_docker_22_04.sh | bash
```

### Ubuntu 24.04+

```bash
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/install_rootless_docker_24_03.sh | bash
```

**Important:** Run as regular user (not root). The script will use sudo when needed.

## Install NVIDIA Container Toolkit

```bash
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/nvidia-container-tool.sh | sudo bash
```

## Complete Setup Workflow

1. Install NVIDIA GPU driver (requires reboot)
2. Install Docker rootless mode (choose appropriate version)
3. Install NVIDIA Container Toolkit
4. Test GPU access: `docker run --rm --gpus all nvidia/cuda:12.2.2-base-ubi8 nvidia-smi`
