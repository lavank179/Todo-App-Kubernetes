#!/bin/bash

ls -ltr && cd frontend && docker build -t ${DOCKER_IMAGE} .
docker images | grep ${DOCKER_IMAGE}

echo "user: $DOCKER_USER"
echo "user: $DOCKER_PASS"

echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin
docker push ${DOCKER_IMAGE}
echo "Pushed successfully!"