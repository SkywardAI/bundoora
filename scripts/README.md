# Bundoora Installation Scripts

This repository contains a set of shell scripts that automate the installation and configuration of NVIDIA GPU drivers and the NVIDIA Container Toolkit on Ubuntu-based systems. These scripts simplify the process of setting up your machine for GPU-accelerated applications and Docker-based workflows.


## Install the NVIDIA GPU Driver

```bash
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/nvidia-gpu-driver.sh | sudo -E bash -
```

## Install Docker

`install_rootless_docker.sh` will support you remove current version of docker and install the recommended version of docker for Debian/Ubuntu seriesly automatically.

### Download and execute the setup script for docker

```bash
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/install_rootless_docker.sh |sudo -E bash -
```

The result should be
```
Docker rootless installation is complete.
For future sessions, add the following lines to your ~/.bashrc or ~/.profile:
export PATH="$HOME/bin:$PATH"
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
```

### Permission denied
```bash
ubuntu@ip-10-0-45-87:~$ docker ps -a
permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.47/containers/json?all=1": dial unix /var/run/docker.sock: connect: permission denied
```

### Apply new group membership

```bash
newgrp docker
```

and you are good to go

```bash
ubuntu@ip-10-0-45-87:~$  docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## Configure the NVIDIA Container Toolkit Repository

```bash
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/nvidia-container-tool.sh | sudo -E bash -
```
