#!/bin/bash

PROJECT_COUNT=$(gcloud projects list --format json | jq .[].name | tr -d \" | wc -l)
if (( PROJECT_COUNT == 1)); then
  PROJECT_NAME=$(gcloud projects list --format json | jq .[].name | tr -d \" )
  echo "Using project $PROJECT_NAME"
fi
if [[ -z $PROJECT_NAME ]]; then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=kubernetes-fundamentals
export NETWORK_NAME=$CLUSTER_NAME
export FIREWALL_NAME=$CLUSTER_NAME

set -euxo pipefail

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# create networks
gcloud compute networks create $NETWORK_NAME --project=$PROJECT_NAME \
  --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
gcloud compute networks subnets create $NETWORK_NAME-subnet --project=$PROJECT_NAME \
  --range=10.0.0.0/24 --network=$NETWORK_NAME --region=$REGION

# create cluster
gcloud beta container clusters create $CLUSTER_NAME \
  --network "projects/$PROJECT_NAME/global/networks/$NETWORK_NAME" --subnetwork "projects/$PROJECT_NAME/regions/$REGION/subnetworks/$NETWORK_NAME-subnet" \
  --services-ipv4-cidr=10.0.1.0/24 --default-max-pods-per-node=110 \
  --zone=$ZONE \
  --cluster-version "1.18.12-gke.1205" \
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
