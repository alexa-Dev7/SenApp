# Use official Debian base image
FROM debian:latest

# Set non-interactive frontend to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package list & install dependencies
RUN apt-get update && apt-get install -y \
    g++ make curl uwebsockets libssl-dev \
    php-cli php-json php-cgi php-mbstring php-xml php-bcmath \
    nginx supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /sender

# Copy all project files
COPY . .

# Expose required ports
EXPOSE 8000 9001

# Run startup script
CMD ["/bin/sh", "start.sh"]
