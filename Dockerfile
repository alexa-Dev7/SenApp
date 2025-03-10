# Use a base image with dependencies
FROM debian:latest

# Install necessary dependencies
RUN apt update && apt install -y \
    cmake g++ make git libssl-dev zlib1g-dev

# Clone and build uWebSockets
RUN git clone --recurse-submodules https://github.com/uNetworking/uWebSockets.git && \
    cd uWebSockets && ls -lah && \
    [ -f CMakeLists.txt ] || (echo "CMakeLists.txt missing! Fixing..." && git checkout v20.47.0 && cmake .) && \
    mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && make install && \
    cd ../.. && rm -rf uWebSockets

# Set the working directory
WORKDIR /app

# Copy your project files into the container
COPY . /app

# Compile your C++ project
RUN g++ -o server main.cpp -luWS -lssl -lz -std=c++17

# Expose the necessary port
EXPOSE 3000

# Run the server
CMD ["./server"]
