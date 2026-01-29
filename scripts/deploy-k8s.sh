#!/bin/bash

DELETE=$1
FILES=("namespace" "persistent-volume" "mongodb" "todo-app-storage-pv" "backend" "frontend" "fluent-daemonset")
total_files=${#FILES[@]}

function deployYML {
    FILE=$1
    kubectl apply -f $FILE
}

function deleteYML {
    FILE=$1
    kubectl delete -f $FILE
}

if [[ $DELETE == "delete" ]]; then
    echo "Deleting Todo-App-Kubernetes deployment"
    kubectl delete configmap fluent-bit-configs
    for (( i=(($total_files-1)); i>=0; i-- )); do
      file="${FILES[$i]}.yml"
      deleteYML "./kubernetes_deployment/$file"
    done
    echo "Completed Todo-App-Kubernetes deletion"
else
    echo "Starting Todo-App-Kubernetes deployment"
    kubectl create configmap fluent-bit-configs --from-file=./logging_and_monitoring/fluent_bit/fluent-bit.conf --from-file=./logging_and_monitoring/fluent_bit/parsers.conf --from-file=./logging_and_monitoring/fluent_bit/extract_service.lua
    for (( i=0; i<$total_files; i++ )); do
      file="${FILES[$i]}.yml"
      deployYML "./kubernetes_deployment/$file"
    done
    echo "Completed Todo-App-Kubernetes deployment"
fi