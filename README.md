<div align="center">

# BUNDOORA

<p>
  <a href="https://github.com/SkywardAI/bundoora/actions/workflows/build_and_check.yml">
    <img src="https://github.com/SkywardAI/bundoora/actions/workflows/build_and_check.yml/badge.svg" alt="Building Checking 🚀">
  </a>
  <a href="https://github.com/SkywardAI/bundoora/actions/workflows/release-image.yml">
    <img src="https://github.com/SkywardAI/bundoora/actions/workflows/release-image.yml/badge.svg" alt="Releasing Image 🚀">
  </a>
  <a href="https://github.com/SkywardAI/bundoora/actions/workflows/dependabot/dependabot-updates">
    <img src="https://github.com/SkywardAI/bundoora/actions/workflows/dependabot/dependabot-updates/badge.svg" alt="Dependabot Updates">
  </a>
  <a href="https://github.com/SkywardAI/bundoora/actions/workflows/release-drafter.yml">
    <img src="https://github.com/SkywardAI/bundoora/actions/workflows/release-drafter.yml/badge.svg" alt="Release Drafter 🚀">
  </a>
</p>

</div>

## 🚀 Overview

A tailored development container environment for consistent and efficient machine learning project execution. Encapsulates all necessary dependencies (Python, PyTorch, CUDA, Ubuntu 22.04) to resolve compatibility issues and enhance reproducibility.

Includes automated installation scripts for setting up NVIDIA GPU drivers, Docker rootless mode, and NVIDIA Container Toolkit on Ubuntu systems.

## 📦 Installation Scripts

Quick setup scripts for Ubuntu systems:

```bash
# Install NVIDIA GPU driver (requires reboot)
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/nvidia-gpu-driver.sh | sudo bash

# Install Docker rootless mode
# For Ubuntu 22.04:
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/install_rootless_docker_22_04.sh | bash
# For Ubuntu 24.04+:
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/install_rootless_docker_24_03.sh | bash

# Install NVIDIA Container Toolkit
curl -fsSL https://raw.githubusercontent.com/SkywardAI/bundoora/refs/heads/main/scripts/nvidia-container-tool.sh | sudo bash
```

See [scripts/README.md](scripts/README.md) for detailed instructions.

## 🐳 Docker Images

This repository builds three specialized container images:

| Image | Description | Base | Package Manager |
|-------|-------------|------|----------------|
| `bundoora:conda` | ML development with Conda | Ubuntu 22.04 | Conda |
| `bundoora:uv` | Fast Python development | Ubuntu 22.04 | uv |
| `bundoora:latex` | LaTeX document processing | TeXLive | apt |

All images include:
- NVIDIA GPU support (CUDA 12.1)
- Python 3.10 (conda/uv images)
- PyTorch 2.5.1 with CUDA support
- Zsh with Oh My Zsh
- Git and development tools

## 🛠️ Environment Specifications

<table>
  <tr>
    <th>Component</th>
    <th>Version</th>
  </tr>
  <tr>
    <td><strong>Python</strong></td>
    <td>3.10</td>
  </tr>
  <tr>
    <td><strong>PyTorch</strong></td>
    <td>2.5.1</td>
  </tr>
  <tr>
    <td><strong>OS</strong></td>
    <td>AWS Ubuntu 24.03</td>
  </tr>
  <tr>
    <td><strong>CUDA</strong></td>
    <td>12.1</td>
  </tr>
</table>


## 🔨 Build Commands

<details>
<summary><strong>Build Options</strong></summary>

| Command | Description |
|---------|-------------|
| `make build` | Build for default platform (linux/amd64) |
| `make build-multi` | Build for multiple platforms (local) |
| `make push-multi IMAGE_NAME=yourusername/test` | Build and push to registry |
| `make create-builder` | Create new builder instance |

</details>


## 📚 Research Projects

<ul>
  <li><a href="https://github.com/Aisuko/clear">When Simpler Is Better: Traditional Models Outperform LLMs in ICU Mortality Prediction</a></li>
  <li><a href="https://github.com/SkywardAI/ramanujan">Small Language Model good at specific tasks</a></li>
  <li><a href="https://github.com/Aisuko/ChronoScribe">ChronoScribe: Early fusion with transformer architecture - PRIVATE</a></li>
  <li><a href="https://github.com/Aisuko/rp-llm-council">LLM Council</a></li>
  <li><a href="https://github.com/Aisuko/cv">CV - PRIVATE</a></li>
</ul>


## 📄 Citation

```bibtex
@software{Li_Bundoora_2024,
  author = {Li, Bowen},
  doi = {<>},
  month = dec,
  title = {{Bundoora}},
  url = {https://github.com/SkywardAI/bundoora},
  version = {1.0.0},
  year = {2024}
}
```