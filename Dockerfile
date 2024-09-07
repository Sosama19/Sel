# Use an official Ubuntu base image
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    lua5.1 \
    luarocks \
    libtorch-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Torch
RUN git clone https://github.com/torch/distro.git /torch --recursive \
    && cd /torch \
    && bash install-deps \
    && ./install.sh \
    && cd / \
    && rm -rf /torch

# Set the environment variables
ENV PATH="/root/torch/install/bin:${PATH}"
ENV LUA_PATH="/root/torch/install/share/lua/5.1/?.lua;;"
ENV LUA_CPATH="/root/torch/install/lib/lua/5.1/?.so;;"

# Set the working directory
WORKDIR /app

# Copy the application files
COPY . /app

# Install Torch dependencies
RUN luarocks install torch \
    && luarocks install nn \
    && luarocks install image

# Command to run the application
CMD ["th", "app.lua"]
