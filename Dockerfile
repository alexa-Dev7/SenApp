# Use Debian as a base
FROM debian:latest

# Install required dependencies
RUN apt update && apt install -y \
    git cmake make g++ libssl-dev libuv1-dev zlib1g-dev openssl

# Clone and build uWebSockets
RUN git clone --recurse-submodules --branch v20.30.0 https://github.com/uNetworking/uWebSockets.git && \
    cd uWebSockets && mkdir build && cd build && \
    cmake -DUWS_WITHOUT_SSL=OFF -DUWS_WITH_PROXY=ON .. && \
    make -j$(nproc) && make install && \
    cd ../.. && rm -rf uWebSockets

# Set working directory for the app
WORKDIR /app
COPY . .

# Compile the C++ app
RUN g++ -o uws-server main.cpp -luWS -lssl -lz -luv -pthread -std=c++17

# Expose the port
EXPOSE 3000

# Run the compiled binary
CMD ["/app/uws-server"]
