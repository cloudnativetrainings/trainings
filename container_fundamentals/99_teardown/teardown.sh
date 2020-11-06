#!/bin/bash

if [[ -z ${PROJECT_NAME} ]]
then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
export REGION=europe-west3
export ZONE=europe-west3-a
export TRAINING_NAME=container-fundamentals
export VM_NAME=$TRAINING_NAME
export NETWORK_NAME=$TRAINING_NAME
export FIREWALL_NAME=$TRAINING_NAME

set -euxo pipefail

gcloud beta compute instances delete $VM_NAME --project=$PROJECT_NAME --zone=$ZONE --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME-allow-http --project=$PROJECT_NAME --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME-allow-https --project=$PROJECT_NAME --quiet
gcloud compute networks subnets delete $NETWORK_NAME-subnet --project=$PROJECT_NAME --quiet
gcloud compute networks delete $NETWORK_NAME --project=$PROJECT_NAME --quiet
