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

gcloud beta compute --project=$PROJECT_NAME instances delete $VM_NAME --zone=$ZONE --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME-allow-http --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME-allow-https --quiet
gcloud compute networks subnets delete $NETWORK_NAME-subnet --quiet
gcloud compute networks delete $NETWORK_NAME --quiet
