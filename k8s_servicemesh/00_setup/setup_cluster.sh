#!/bin/bash

set -euxo pipefail

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

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# create networks
gcloud compute networks create $NETWORK_NAME --subnet-mode=custom
gcloud compute networks subnets create $SUB_NETWORK_NAME --network=$NETWORK_NAME --range=10.0.0.0/24

# create cluster
gcloud beta container clusters create $CLUSTER_NAME \
  --network "projects/$PROJECT_NAME/global/networks/$NETWORK_NAME" --subnetwork "projects/$PROJECT_NAME/regions/$REGION/subnetworks/$SUB_NETWORK_NAME" \
  --services-ipv4-cidr=10.0.1.0/24 --default-max-pods-per-node=110 \
  --zone=$ZONE \
  --cluster-version "1.17.12-gke.2502" \
  --machine-type "n1-standard-4" --num-nodes "2" \
  --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --default-max-pods-per-node "110" \
  --enable-network-policy --enable-ip-alias \
  --no-enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 \
  --no-enable-basic-auth --metadata disable-legacy-endpoints=true \
  --no-enable-stackdriver-kubernetes --no-enable-master-authorized-networks \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing

### add firewall rule for ingress gateway
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
