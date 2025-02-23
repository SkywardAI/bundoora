#!/bin/bash

set -e # Exit immediately if nay command fails

apt-get update -y

# Install gcc
apt -y install gcc

# We will use the ubuntu-drivers tool to install the NVIDIA Drivers.
apt -y install ubuntu-drivers-common

# Installing the driver that is considered the best match for the hardware
ubuntu-drivers --gpgpu install

# output the author should reboot the machine
echo "Please reboot the machine to apply the changes"
