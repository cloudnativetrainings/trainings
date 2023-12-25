#!/bin/bash

PROJECT_COUNT=$(gcloud projects list --format json | jq .[].name | tr -d \" | wc -l)
if (( PROJECT_COUNT == 1)); then
  PROJECT_NAME=$(gcloud projects list --format json | jq .[].name | tr -d \" )
  echo "Using project $PROJECT_NAME"
fi
if [[ -z $PROJECT_NAME ]]; then
  echo "INPUT: Type PROJECT_NAME: " && read PROJECT_NAME
fi
export REGION=europe-west6
export ZONE=europe-west6-a
export CLUSTER_NAME=training-kad
export NETWORK_NAME=$CLUSTER_NAME
export FIREWALL_NAME=$CLUSTER_NAME

set -euxo pipefail

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# delete resources
gcloud beta container clusters delete $CLUSTER_NAME --quiet
gcloud compute addresses delete $CLUSTER_NAME-addr --region=$REGION --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME-ingress-gateway --quiet
gcloud compute networks subnets delete $NETWORK_NAME-subnet --quiet
gcloud compute networks delete $NETWORK_NAME --quiet
