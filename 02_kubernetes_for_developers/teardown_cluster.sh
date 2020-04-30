#!/bin bash

export PROJECT_NAME=ps-workspace
export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=training-loodse
export NETWORK_NAME=$CLUSTER_NAME
export FIREWALL_NAME=$CLUSTER_NAME

gcloud beta container clusters delete $CLUSTER_NAME
gcloud compute firewall-rules delete $FIREWALL_NAME
gcloud compute networks delete $NETWORK_NAME 
