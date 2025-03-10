# Use Debian for a minimal environment
FROM debian:latest

# Install dependencies
RUN apt update && apt install -y \
    git cmake make g++ libssl-dev zlib1g-dev

# Clone the correct uWebSockets branch and check files
RUN git clone --recurse-submodules --branch v20.47.0 https://github.com/uNetworking/uWebSockets.git && \
    cd uWebSockets && \
    ls -lah && \
    [ -f CMakeLists.txt ] || (echo "CMakeLists.txt missing!" && exit 1) && \
    mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) && make install && \
    cd ../.. && rm -rf uWebSockets

# Set working directory
WORKDIR /app
COPY . .

# Compile your C++ app
RUN g++ -o uws-server main.cpp -luWS -lssl -lz -std=c++17

# Expose the port
EXPOSE 3000

# Run the app
CMD ["./uws-server"]
