# Use Debian as base image
FROM debian:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    git cmake make g++ \
    libssl-dev libuv1-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

# Clone uWebSockets manually
WORKDIR /usr/local
RUN git clone --recurse-submodules https://github.com/uNetworking/uWebSockets.git uWebSockets
WORKDIR /usr/local/uWebSockets
RUN git checkout v20.47.0
RUN git submodule update --init --recursive

# Build and install uWebSockets
RUN make -j$(nproc) && make install

# Ensure headers are available
RUN cp -r src /usr/local/include/uWebSockets

# Clean up
WORKDIR /usr/local
RUN rm -rf uWebSockets

# Set working directory for the app
WORKDIR /app
COPY . /app

# Compile C++ server (FIXED HEADER PATH)
RUN g++ -std=c++17 -o server server.cpp -I/usr/local/include -L/usr/local/lib -luWS -lssl -lz -lpthread

# Expose the port
EXPOSE 3000

# Start the server
CMD ["./server"]
