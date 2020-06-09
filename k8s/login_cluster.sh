#!/bin/bash

if [[ -z ${PROJECT_NAME} ]]
then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
# variables
export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=training-loodse
export NETWORK_NAME=$CLUSTER_NAME
export FIREWALL_NAME=$CLUSTER_NAME

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# connect to cluster
gcloud container clusters get-credentials $CLUSTER_NAME 
echo 'source <(kubectl completion bash)' >> ~/.bashrc && source ~/.bashrc

# verify
# kubectl run my-pod --generator run-pod/v1 --image nginx --port 80 -l app=my-pod
# kubectl expose pod my-pod --type NodePort
# export NODE=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[?(@.type=='ExternalIP')].address}")
# export PORT=$(kubectl get svc my-pod -o jsonpath="{.spec.ports[0].nodePort}")
# curl http://$NODE:$PORT
# kubectl delete pod,svc my-pod
