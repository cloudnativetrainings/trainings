#!/bin/bash

#set -euxo pipefail

# variables
if [[ -z ${PROJECT_NAME} ]]
then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=training-loodse
export NETWORK_NAME=$CLUSTER_NAME
export SUB_NETWORK_NAME=$CLUSTER_NAME-subnet
export FIREWALL_NAME=$CLUSTER_NAME
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/$CLUSTER_NAME

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

gcloud beta container clusters delete $CLUSTER_NAME --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME-ingress-gateway --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME-ssh --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME-nodeport --quiet
gcloud compute networks subnets delete $SUB_NETWORK_NAME  --quiet
gcloud compute networks delete $NETWORK_NAME  --quiet
