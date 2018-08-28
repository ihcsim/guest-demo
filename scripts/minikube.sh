#!/bin/bash

minikube_status=`minikube status --format {{.MinikubeStatus}}`
if [ "${minikube_status}" == "Running" ]; then
  exit 0
fi

# adding the minikube private IP range to the acceptable insecure registries CIDR will allows images to be tagged and pushed from the host machine
minikube start --vm-driver hyperkit --cpus 2 --memory 3096 --insecure-registry "192.168.0.0/16"

# enable add-ons
minikube addons enable metrics-server
minikube addons enable heapster
minikube addons enable registry
