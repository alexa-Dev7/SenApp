#!/bin/bash

# Read Render-assigned PORT
export PORT=${PORT:-9001} # Default to 9001 if not set

# Start PHP built-in server
php -S 0.0.0.0:8000 -t /app &

# Start C++ WebSocket server
./server &

# Keep the container running
tail -f /dev/null
