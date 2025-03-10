# Use a lightweight Debian-based image
FROM debian:latest

# Install dependencies
RUN apt update && apt install -y \
    g++ make curl uwebsockets libssl-dev \
    php-cli php-json php-cgi php-mbstring php-xml php-bcmath \
    nginx supervisor

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Expose only one port (Render assigns dynamically)
EXPOSE 8000

# Set file permissions
RUN chmod +x start.sh

# Start PHP & WebSocket server
CMD ["/bin/bash", "start.sh"]
