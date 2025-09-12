#!/bin/bash
set -eox

function buildAndPushImage() {
  DOCKER_IMAGE="$1:$BUILD_NUMBER"
  docker build -t ${DOCKER_IMAGE} .

  docker images --format '{{.Repository}}:{{.Tag}}' --filter=reference="$1" | sort -t: -k2 -n | head -n -2 | xargs -r docker rmi
  echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin
  docker push ${DOCKER_IMAGE}
}

ls -ltr
cd frontend
buildAndPushImage "lavank179/todo-k8s-ui"
cd ..

cd backend
buildAndPushImage "lavank179/todo-k8s-api"
cd ..

echo "Pushed successfully!"

