# Gunakan image resmi CUDA 12.9 berbasis Ubuntu 22.04
FROM nvidia/cuda:12.9.0-devel-ubuntu22.04

# Atur frontend agar non-interaktif saat apt install
ENV DEBIAN_FRONTEND=noninteractive

# Update & install semua dependencies yang diperlukan
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    wget \
    unzip \
    pkg-config \
    libssl-dev \
    python3 \
    python3-pip \
    python3-venv \
    clang \
    libclang-dev \
    ca-certificates \
    sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup update

WORKDIR /app
RUN git clone https://github.com/boundless-xyz/boundless.git
WORKDIR /app/boundless
RUN git checkout release-0.12

# Build Boundless prover
RUN cargo build --release --package prover

# Clone RISC Zero
WORKDIR /app
RUN git clone https://github.com/risc0/risc0.git
WORKDIR /app/risc0
RUN git checkout main

# Build RISC Zero agent
RUN cargo build --release --package risc0-agent

# Set default working directory
WORKDIR /app

# Entry point default
CMD ["bash"]
