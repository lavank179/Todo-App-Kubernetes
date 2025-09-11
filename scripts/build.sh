#!/bin/bash

ls -ltr && cd frontend && docker build -t ${DOCKER_IMAGE} .
docker images | grep ${ DOCKER_IMAGE }
docker push ${ DOCKER_IMAGE }
echo "Pushed successfully!"