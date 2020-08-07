#!/bin/bash

# variables
export PROJECT_NAME=loodse-training-playground
export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=training-loodse
export NETWORK_NAME=$CLUSTER_NAME
export FIREWALL_NAME=$CLUSTER_NAME
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/$CLUSTER_NAME

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

gcloud beta container clusters delete $CLUSTER_NAME --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME-ingress-gateway --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME-ssh --quiet
gcloud compute networks delete $NETWORK_NAME  --quiet
