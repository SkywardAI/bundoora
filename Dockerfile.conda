# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/opt/conda/bin:$PATH"

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    bzip2 \
    build-essential \
    zsh \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install ubuntu-drivers-common
RUN apt-get update && \
    apt-get install -y ubuntu-drivers-common && \
    rm -rf /var/lib/apt/lists/*

# Install NVIDIA drivers
RUN ubuntu-drivers autoinstall

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    /opt/conda/bin/conda clean --all -y

# Create a new Conda environment with Python 3.10
RUN /opt/conda/bin/conda create -y --name py310 python=3.10

# Install PyTorch with CUDA support using conda run
RUN /opt/conda/bin/conda run -n py310 conda install -y pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Set Zsh as the default shell
RUN chsh -s $(which zsh)

# Ensure the Conda environment is activated by default in new zsh sessions
RUN echo "source /opt/conda/bin/activate py310" >> /root/.zshrc

# Set the working directory
WORKDIR /workspace

# (Optional) Copy your application code into the container
# COPY . /workspace

# Set the default shell to Zsh
CMD ["zsh"]
