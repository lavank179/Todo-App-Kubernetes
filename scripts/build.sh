#!/bin/bash

ls -ltr && cd frontend && docker build -t ${DOCKER_IMAGE} .
docker images | grep ${DOCKER_IMAGE}

echo "user: $REGISTRY_CREDENTIALS_Username"
echo "user: $REGISTRY_CREDENTIALS_Password"

echo "$REGISTRY_CREDENTIALS_Password" | docker login --username "$REGISTRY_CREDENTIALS_Username" --password-stdin
docker push ${DOCKER_IMAGE}
echo "Pushed successfully!"