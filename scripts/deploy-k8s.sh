#!/bin/bash

function deploy {
    FILE=$1
    kubectl apply -f $FILE
}

echo "Starting Todo-App-Kubernetes deployment"
deploy "./kubernetes_deployment/namespace.yml"
deploy "./kubernetes_deployment/mongodb.yml"
echo "Completed Todo-App-Kubernetes deployment"