#!/bin/bash

if [[ -z ${PROJECT_NAME} ]]
then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
# variables
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
    --machine-type "e2-standard-4" --num-nodes "2" \
    --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "50" \
    --enable-network-policy --enable-ip-alias --no-enable-autoupgrade --no-enable-stackdriver-kubernetes \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing

### add firewall rule for node port range
gcloud compute firewall-rules create $FIREWALL_NAME-nodeport \
--network $NETWORK_NAME \
--direction=INGRESS \
--action=ALLOW \
--source-ranges=0.0.0.0/0 \
--rules=tcp:30000-32767

### add ssh access for nodes
gcloud compute firewall-rules create $FIREWALL_NAME-ssh \
 --direction=INGRESS \
 --network=$NETWORK_NAME \
 --action=ALLOW \
  --source-ranges=0.0.0.0/0 \
  --rules=tcp:22

# connect to cluster
gcloud container clusters get-credentials $CLUSTER_NAME 
echo 'source <(kubectl completion bash)' >> ~/.bashrc && source ~/.bashrc

