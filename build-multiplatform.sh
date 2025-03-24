#!/bin/bash

# Enable Docker BuildKit
export DOCKER_BUILDKIT=1

# Set variables
DOCKER_USERNAME="twunhuman"
IMAGE_NAME="unichat"
TAG="latest"

# Create a builder instance if it doesn't exist
if ! docker buildx inspect multiplatform-builder > /dev/null 2>&1; then
  echo "Creating new builder instance..."
  docker buildx create --name multiplatform-builder --use
fi

# Use the builder
docker buildx use multiplatform-builder

# Build and push the images
echo "Building and pushing multi-platform images..."
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG} \
  -f Dockerfile.production \
  --push \
  .

echo "Build and push completed successfully!"
