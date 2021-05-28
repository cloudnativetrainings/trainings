#!/bin/bash

if [[ -z ${PROJECT_NAME} ]]
then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
# variables
export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=k8c-master
export NETWORK_NAME=$CLUSTER_NAME
export FIREWALL_NAME=$CLUSTER_NAME
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/$CLUSTER_NAME

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

gcloud beta container clusters delete $CLUSTER_NAME --quiet
gcloud compute firewall-rules $FIREWALL_NAME-nodeport --quiet
gcloud compute firewall-rules $FIREWALL_NAME-ssh --quiet
gcloud compute networks delete $NETWORK_NAME  --quiet

# TODO
# gcloud container images list --repository eu.gcr.io/loodse-training-playground/loodse-training
# for image in $(gcloud container images list --repository eu.gcr.io/loodse-training-playground/loodse-training --format='get(name)'); \
#   do gcloud container images delete -q --force-delete-tags ${image}; \
# done;