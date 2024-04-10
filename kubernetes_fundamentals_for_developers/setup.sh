#!/bin/bash

PROJECT_COUNT=$(gcloud projects list --format json | jq .[].name | tr -d \" | wc -l)
if (( PROJECT_COUNT == 1)); then
  PROJECT_NAME=$(gcloud projects list --format json | jq .[].name | tr -d \" )
  echo "Using project $PROJECT_NAME"
fi
if [[ -z $PROJECT_NAME ]]; then
  echo "INPUT: Type PROJECT_NAME:" && read PROJECT_NAME
fi

export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=training-kf

set -euxo pipefail

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# create static IP address for NGINX ingress
response_addr=`gcloud compute addresses list --filter=region:$REGION --filter="name=$CLUSTER_NAME-addr"`
if [ -z "$response_addr" ]
then
  gcloud compute addresses create $CLUSTER_NAME-addr --region=$REGION
else
  echo "Static IP Address already exists, skip creation"
fi

# install NGINX ingress
export INGRESS_IP=$(gcloud compute addresses list --filter="name=training-kad-addr" --format="get(address)")
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --version 4.9.0 \
  --set controller.service.loadBalancerIP=${INGRESS_IP}

# install Prometheus
helm upgrade --install monitoring kube-prometheus-stack \
  --repo https://prometheus-community.github.io/helm-charts \
  --namespace monitoring --create-namespace \
  --version 55.7.1 \
  --set grafana.ingress.enabled=true,grafana.ingress.ingressClassName=nginx

# install Loki
helm upgrade --install logging loki-stack \
    --repo https://grafana.github.io/helm-charts \
    --namespace logging --create-namespace \
    --version 2.10.0 \
    --set fluent-bit.enabled=true,promtail.enabled=false
