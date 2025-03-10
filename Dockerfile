# Use Debian as base image
FROM debian:latest

# Set non-interactive frontend to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package list & install required dependencies
RUN apt-get update && apt-get install -y \
    g++ make cmake curl libssl-dev \
    php-cli php-json php-cgi php-mbstring php-xml php-bcmath \
    nginx supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install uWebSockets manually using CMake
RUN curl -fsSL https://github.com/uNetworking/uWebSockets/archive/v20.30.0.tar.gz | tar xz && \
    cd uWebSockets-20.30.0 && \
    mkdir build && cd build && \
    cmake .. && make && make install && \
    cd ../.. && rm -rf uWebSockets-20.30.0

# Set working directory
WORKDIR /sender

# Copy all project files
COPY . .

# Expose required ports
EXPOSE 8000 9001

# Run startup script
CMD ["/bin/sh", "start.sh"]
