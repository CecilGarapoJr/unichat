# Enable Docker BuildKit
$env:DOCKER_BUILDKIT=1

# Set the image name and tag
$IMAGE="unichat"
$TAG="latest"

# Create and use a new builder instance
docker buildx create --use --name multiarch-builder

# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 `
  --tag "${IMAGE}:${TAG}" `
  --push `
  .
