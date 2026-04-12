#!/bin/bash
set -eox

TASK="${1}"
IMAGEREPO="${IMAGE_REPO}"
BUILDNUMBER="${BUILD_NUMBER}"

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
  docker build -t "$IMAGEREPO/frontend:$BUILDNUMBER" .
  cd ../backend
  docker build -t "$IMAGEREPO/backend:$BUILDNUMBER" .
  echo "Containers built successfully!"
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
else
  echo "Unknown argument for task: $TASK, select either 'build_containers' or 'test_containers'"
  exit 1
fi
