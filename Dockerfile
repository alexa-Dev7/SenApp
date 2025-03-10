# Use an official C++ image with required tools
FROM debian:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone and build uWebSockets
RUN git clone --recurse-submodules https://github.com/uNetworking/uWebSockets.git && \
    cd uWebSockets && \
    git submodule update --init && \
    mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && make install && \
    cd ../.. && rm -rf uWebSockets

# Copy project files into container
WORKDIR /app
COPY . /app

# Compile the C++ application
RUN g++ -std=c++17 -o server main.cpp -luWS -lssl -lz -lpthread

# Expose the port your server runs on
EXPOSE 9001

# Run the application
CMD ["./server"]
