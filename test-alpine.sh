#!/bin/bash

# Build the Docker image
echo "Building Docker image..."
docker build -f Dockerfile.test -t mars-alpine-test .

# Run the container with the current directory mounted
echo "Running container with mounted directory..."
docker run -it --rm \
    -v "$(pwd):/mars" \
    -w /mars \
    mars-alpine-test \
    /bin/sh 