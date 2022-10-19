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
export CLUSTER_NAME=training-kf
export NETWORK_NAME=$CLUSTER_NAME
export FIREWALL_NAME=$CLUSTER_NAME
export CLUSTER_VERSION=1.22

set -euxo pipefail

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# create networks
response_network=`gcloud compute networks list --filter="name=$NETWORK_NAME" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_network" ]
then
  gcloud compute networks create $NETWORK_NAME --project=$PROJECT_NAME \
    --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
else
      echo "Network $response_network already exists, skip creation"
fi

# create subnet
response_subnet=`gcloud compute networks subnets list --filter="name=$NETWORK_NAME-subnet" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_subnet" ]
then
  gcloud compute networks subnets create $NETWORK_NAME-subnet --project=$PROJECT_NAME \
    --range=10.0.0.0/24 --network=$NETWORK_NAME --region=$REGION
else
      echo "Subnet $response_network already exists, skip creation"
fi

# create cluster
response_cluster=`gcloud beta container clusters list --filter="name=$CLUSTER_NAME" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_cluster" ]
then
  gcloud beta container clusters create $CLUSTER_NAME \
    --network "projects/$PROJECT_NAME/global/networks/$NETWORK_NAME" --subnetwork "projects/$PROJECT_NAME/regions/$REGION/subnetworks/$NETWORK_NAME-subnet" \
    --services-ipv4-cidr=10.0.1.0/24 --default-max-pods-per-node=110 \
    --zone=$ZONE \
    --cluster-version $CLUSTER_VERSION \
    --machine-type "n1-standard-4" --num-nodes "2" \
    --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" \
    --enable-network-policy --enable-ip-alias \
    --no-enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 \
    --no-enable-basic-auth --metadata disable-legacy-endpoints=true \
    --no-enable-stackdriver-kubernetes --no-enable-master-authorized-networks \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing
else
      echo "Cluster $response_cluster already exists, skip creation"
fi

# add firewall rule for ingress gateway
response_firewall_ingress=`gcloud compute firewall-rules list --filter="$FIREWALL_NAME-ingress-gateway" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_firewall_ingress" ]
then
  gcloud compute firewall-rules create $FIREWALL_NAME-ingress-gateway \
    --network $NETWORK_NAME \
    --direction=INGRESS \
    --action=ALLOW \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:80,tcp:8080,tcp:443
else
      echo "Firewall $response_firewall_ingress already exists, skip creation"
fi

# add ssh access for nodes
response_firewall_ssh=`gcloud compute firewall-rules list --filter="$FIREWALL_NAME-ssh" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_firewall_ssh" ]
then
  gcloud compute firewall-rules create $FIREWALL_NAME-ssh \
    --direction=INGRESS \
    --network=$NETWORK_NAME \
    --action=ALLOW \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:22
else
      echo "Firewall $response_firewall_ssh already exists, skip creation"
fi

# add access to NodePort services
response_firewall_nodeport=`gcloud compute firewall-rules list --filter="$FIREWALL_NAME-nodeport" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_firewall_nodeport" ]
then
  gcloud compute firewall-rules create $FIREWALL_NAME-nodeport \
    --direction=INGRESS \
    --network=$NETWORK_NAME \
    --action=ALLOW \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:30000-32767
else
      echo "Firewall $response_firewall_nodeport already exists, skip creation"
fi

# connect to cluster
gcloud container clusters get-credentials $CLUSTER_NAME 
echo 'source <(kubectl completion bash)' >> ~/.bashrc && source ~/.bashrc
