# Use a base image with build tools
FROM debian:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    git cmake make g++ \
    libssl-dev libuv1-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Clone uWebSockets and build
RUN git clone --recurse-submodules https://github.com/uNetworking/uWebSockets.git && \
    cd uWebSockets && \
    git checkout v20.47.0 && \
    git submodule update --init --recursive && \
    mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && make install && \
    cd ../.. && rm -rf uWebSockets

# Set working directory for your app
WORKDIR /app
COPY . /app

# Compile your C++ code (adjust as needed)
RUN g++ -std=c++17 -o server server.cpp -luWS -lssl -lz -lpthread

# Expose the required port
EXPOSE 3000

# Start the server
CMD ["./server"]
