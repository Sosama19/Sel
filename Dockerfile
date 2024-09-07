# Use a base image with Lua and Torch installed
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    lua5.1 \
    libtorch-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Torch
RUN wget http://torch.ch/extra/cutorch-1.0.0-py2.7-linux-x86_64.tar.gz \
    && tar -xvf cutorch-1.0.0-py2.7-linux-x86_64.tar.gz \
    && cp -r cutorch /usr/local/share/torch/ \
    && rm cutorch-1.0.0-py2.7-linux-x86_64.tar.gz

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
