# Use Debian as base image
FROM debian:latest

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git g++ make cmake libssl-dev \
    php-cli php-json php-cgi php-mbstring php-xml php-bcmath \
    nginx supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone and build uWebSockets
RUN git clone --recursive --branch v20.30.0 https://github.com/uNetworking/uWebSockets.git && \
    cd uWebSockets && \
    mkdir build && cd build && \
    cmake .. && make -j$(nproc) && make install && \
    cd ../.. && rm -rf uWebSockets

# Set working directory
WORKDIR /sender

# Copy project files
COPY . .

# Expose required ports
EXPOSE 8000 9001

# Run startup script
CMD ["/bin/sh", "start.sh"]
