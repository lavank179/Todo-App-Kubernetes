#!/bin/bash
set -eo

ls -ltr
cd frontend
docker build -t ${DOCKER_IMAGE} .
cd ..
docker images | grep ${DOCKER_IMAGE}

docker images --format '{{.Repository}}:{{.Tag}}' --filter=reference='lavank179/todo-k8s-ui' | sort -t: -k2 -n | head -n -2 | xargs -r docker rmi
echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin
docker push ${DOCKER_IMAGE}
echo "Pushed successfully!"

