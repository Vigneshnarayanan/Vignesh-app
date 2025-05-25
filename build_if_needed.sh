#!/bin/bash

IMAGE_NAME="vign511/backend"
DOCKERFILE_PATH="backend/Dockerfile"
BUILD_CONTEXT="."

# Get the latest modification time of Dockerfile and app source files (in seconds since epoch)
LATEST_SOURCE_MOD_TIME=$(find backend -type f -name '*.py' -o -name 'Dockerfile' -print0 | xargs -0 stat -f "%m" | sort -nr | head -1)

# Check if the image exists
IMAGE_EXISTS=$(docker image inspect "$IMAGE_NAME" > /dev/null 2>&1 && echo "yes" || echo "no")

if [ "$IMAGE_EXISTS" == "yes" ]; then
  # Get image creation timestamp with fractional seconds (e.g. 2025-05-24T09:39:35.737894251Z)
  RAW_TIMESTAMP=$(docker image inspect --format='{{.Created}}' "$IMAGE_NAME")
  
  # Strip fractional seconds for macOS date compatibility
  IMAGE_CREATED=$(echo "$RAW_TIMESTAMP" | sed -E 's/\.[0-9]+Z/Z/')
  
  # Convert image creation time to epoch seconds (macOS date syntax)
  IMAGE_TIMESTAMP=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$IMAGE_CREATED" "+%s")
  
  # Compare timestamps and decide if rebuild is needed
  if [ "$LATEST_SOURCE_MOD_TIME" -le "$IMAGE_TIMESTAMP" ]; then
    echo "No changes detected. Using existing image $IMAGE_NAME:latest."
    exit 0
  else
    echo "Source changed since last image build. Rebuilding image..."
  fi
else
  echo "Image $IMAGE_NAME does not exist. Building image..."
fi

# Build the Docker image
docker build -t "$IMAGE_NAME:latest" -f "$DOCKERFILE_PATH" "$BUILD_CONTEXT"

if [ $? -eq 0 ]; then
  echo "Docker image $IMAGE_NAME built successfully."
else
  echo "Docker build failed."
  exit 1
fi
