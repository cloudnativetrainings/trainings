#!/bin/bash

# build
docker build -t monitor:0.0.1 .

# run
docker run -it --name monitor -p 80:80 monitor:0.0.1

# k8s
#eval $(minikube docker-env)
#kubectl apply -f pod.yaml