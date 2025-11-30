#!/bin/bash
set -eox

IsBuildAndPush="${1:-false}"
BNUMBER="${2:-0}"

function buildAndPushImage() {
  DOCKER_IMAGE="$1:$BUILD_NUMBER"
  docker build -t ${DOCKER_IMAGE} .

  docker images --format '{{.Repository}}:{{.Tag}}' --filter=reference="$1" | sort -t: -k2 -n | head -n -2 | xargs -r docker rmi
  echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin
  docker push ${DOCKER_IMAGE}
}

function buildOnlyImage() {
  BUILD_NUMBER=$2
  DOCKER_IMAGE="$1:$BUILD_NUMBER"
  docker build -t ${DOCKER_IMAGE} .
}

ls -ltr
cd frontend
if [[ "$IsBuildAndPush" == "true" ]]; then
  buildAndPushImage "lavank179/todo-k8s-ui"
else
  buildOnlyImage "lavank179/todo-k8s-ui" $BNUMBER
fi
cd ..

cd backend
if [[ "$IsBuildAndPush" == "true" ]]; then
  buildAndPushImage "lavank179/todo-k8s-api"
else
  buildOnlyImage "lavank179/todo-k8s-api" $BNUMBER
fi
cd ..

echo "Pushed successfully!"

