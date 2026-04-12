#!/bin/bash
set -eox

echo "ftag: $FRONTEND_IMAGE_TAG, btag: $BACKEND_IMAGE_TAG"

TASK="${1}"
FRONTEND_IMAGE_TAG="$FRONTEND_IMAGE_TAG"
BACKEND_IMAGE_TAG="$BACKEND_IMAGE_TAG"

# function buildAndPushImage() {
#   DOCKER_IMAGE="$1:$BUILD_NUMBER"
#   docker build -t ${DOCKER_IMAGE} .

#   docker images --format '{{.Repository}}:{{.Tag}}' --filter=reference="$1" | sort -t: -k2 -n | head -n -2 | xargs -r docker rmi
#   echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin
#   docker push ${DOCKER_IMAGE}
# }

function buildContainers() {
  ls -l
  cd frontend
  docker build -t $FRONTEND_IMAGE_TAG .
  cd ../backend
  docker build -t $BACKEND_IMAGE_TAG .
  echo "Containers built successfully!"
}

function pushContainers() {
  echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin
  docker push $FRONTEND_IMAGE_TAG
  docker push $BACKEND_IMAGE_TAG
  echo "Containers pushed successfully!"
}

function testContainers() {
  echo "Testing containers..."
  # Here you can add commands to run your tests against the built containers
  # For example, you might use docker run to start the containers and then execute test scripts
  docker images
  echo "Tests completed successfully!"
}

if [[ "$TASK" == "build_containers" ]]; then
  buildContainers
elif [[ "$TASK" == "test_containers" ]]; then
  testContainers
elif [[ "$TASK" == "push_containers" ]]; then
  pushContainers
else
  echo "Unknown argument for task: $TASK, select either 'build_containers' or 'test_containers'"
  exit 1
fi
