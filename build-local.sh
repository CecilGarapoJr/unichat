#!/bin/bash

# Build the image
docker build -t twunhuman/unichat:latest -f Dockerfile.production .

# Push to Docker Hub
docker push twunhuman/unichat:latest
