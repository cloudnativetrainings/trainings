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

# create networks
gcloud compute networks create $NETWORK_NAME --subnet-mode=custom

# create cluster
gcloud beta container clusters create $CLUSTER_NAME \
  --network $NETWORK_NAME  --create-subnetwork=name=$NETWORK_NAME-subnet,range=10.0.0.0/24 \
  --services-ipv4-cidr=10.0.1.0/24 --default-max-pods-per-node=110 \
  --zone=$ZONE \
  --cluster-version "1.16.13-gke.1" \
  --machine-type "n1-standard-4" --num-nodes "2" \
  --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "50" \
  --enable-network-policy --enable-ip-alias --no-enable-autoupgrade --no-enable-stackdriver-kubernetes \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing

### add firewall rule for ingreess gateway
gcloud compute firewall-rules create $FIREWALL_NAME-ingress-gateway \
  --network $NETWORK_NAME \
  --direction=INGRESS \
  --action=ALLOW \
  --source-ranges=0.0.0.0/0 \
  --rules=tcp:80,tcp:443

### add ssh access for nodes
gcloud compute firewall-rules create $FIREWALL_NAME-ssh \
  --direction=INGRESS \
  --network=$NETWORK_NAME \
  --action=ALLOW \
  --source-ranges=0.0.0.0/0 \
  --rules=tcp:22

### add access to NodePort services
gcloud compute firewall-rules create $FIREWALL_NAME-nodeport \
  --direction=INGRESS \
  --network=$NETWORK_NAME \
  --action=ALLOW \
  --source-ranges=0.0.0.0/0 \
  --rules=tcp:30000-32767

# connect to cluster
gcloud container clusters get-credentials $CLUSTER_NAME 
echo 'source <(kubectl completion bash)' >> ~/.bashrc && source ~/.bashrc
