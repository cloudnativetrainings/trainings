#!/bin/bash

# variables
export PROJECT_NAME=loodse-training-playground
export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=training-loodse
export NETWORK_NAME=$CLUSTER_NAME
export FIREWALL_NAME=$CLUSTER_NAME

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# install istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.4.3 sh -
mv istio-1.4.3 ~
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.5.6 sh -
mv istio-1.5.6 ~
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.6.3 sh -
mv istio-1.6.3 ~
export PATH=~/istio-1.6.3/bin:$PATH

# install istio into cluster
istioctl manifest apply --set profile=demo
# istioctl manifest generate --set profile=demo > generated-manifest.yaml
# istioctl verify-install -f generated-manifest.yaml

# enable injection 
kubectl label namespace default istio-injection=enabled
kubectl get namespace -L istio-injection