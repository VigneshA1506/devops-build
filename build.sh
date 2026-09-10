#!/bin/bash
 
IMAGE_NAME="devops-build"
IMAGE_TAG="${1:-latest}"
 
echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
 
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .
 
echo "Docker image built successfully."