#!/bin/bash

export PROJECT_NAME=ps-workspace
export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=training-loodse
export NETWORK_NAME=$CLUSTER_NAME
export FIREWALL_NAME=$CLUSTER_NAME
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/loodse-training

gcloud beta container clusters delete $CLUSTER_NAME --quiet
gcloud compute firewall-rules delete $FIREWALL_NAME --quiet
gcloud compute networks delete $NETWORK_NAME  --quiet

# TODO
# gcloud container images list --repository eu.gcr.io/ps-workspace/loodse-training
# for image in $(gcloud container images list --repository eu.gcr.io/ps-workspace/loodse-training --format='get(name)'); \
#   do gcloud container images delete -q --force-delete-tags ${image}; \
# done;