# Use NVIDIA's CUDA 12.2.2 development image based on Red Hat Universal Base Image 8
FROM nvidia/cuda:12.2.2-devel-ubi8

# Set environment variables
ENV PATH="/opt/conda/bin:$PATH"

# Install system dependencies
RUN yum update -y && \
    yum install -y \
    wget \
    bzip2 \
    && yum clean all

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    /opt/conda/bin/conda clean --all -y

# Create a new Conda environment with Python 3.10
RUN conda create -y --name py310 python=3.10

# Activate the environment and install PyTorch with CUDA 12.1 support
RUN /bin/bash -c "source activate py310 && \
    conda install -y pytorch==2.2.2 torchvision==0.17.2 torchaudio==2.2.2 pytorch-cuda=12.1 -c pytorch -c nvidia"

# Set the default environment to 'py310'
ENV CONDA_DEFAULT_ENV=py310
ENV PATH="/opt/conda/envs/py310/bin:$PATH"

# Set the working directory
WORKDIR /workspace

# (Optional) Copy your application code into the container
# COPY . /workspace

# Set the default command to python
CMD ["python"]
