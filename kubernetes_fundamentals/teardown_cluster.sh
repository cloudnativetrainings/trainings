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

set -euxo pipefail

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# delete resources
#Check whether Cluster exists
response_cluster=`gcloud beta container clusters list --filter="name=$CLUSTER_NAME" --format="value(name)" --project=$PROJECT_NAME`

if [ ! -z "$response_cluster" ]
then
  gcloud beta container clusters delete $CLUSTER_NAME --quiet
else
  echo "Cluster $response_cluster doesn't exists, skipped deletion"
fi

# Check whether the Firewall Rules for Ingress Gateway exists
response_firewall_ingress=`gcloud compute firewall-rules list --filter="$FIREWALL_NAME-ingress-gateway" --format="value(name)" --project=$PROJECT_NAME`

if [ ! -z "$response_firewall_ingress" ]
then
  gcloud compute firewall-rules delete $FIREWALL_NAME-ingress-gateway --quiet
else
  echo "Firewall Rules for Ingress Gateway $response_firewall_ingress doesn't exists, skipped deletion"
fi

# Check whether the Firewall Rules for SSH Port exists
response_firewall_ssh=`gcloud compute firewall-rules list --filter="$FIREWALL_NAME-ssh" --format="value(name)" --project=$PROJECT_NAME`

if [ ! -z "$response_firewall_ssh" ]
then
  gcloud compute firewall-rules delete $FIREWALL_NAME-ssh --quiet
else
  echo "Firewall Rules for SSH $response_firewall_ssh doesn't exists, skipped deletion"
fi

# Check whether the Firewall Rules for NodePort access exists
response_firewall_nodeport=`gcloud compute firewall-rules list --filter="$FIREWALL_NAME-nodeport" --format="value(name)" --project=$PROJECT_NAME`

if [ ! -z "$response_firewall_nodeport" ]
then
  gcloud compute firewall-rules delete $FIREWALL_NAME-nodeport --quiet
else
  echo "Firewall Rules for NodePort $response_firewall_nodeport doesn't exists, skipped deletion"
fi

#Check whether Cluster Subnet exists
response_subnet=`gcloud compute networks subnets list --filter="name=$NETWORK_NAME-subnet" --format="value(name)" --project=$PROJECT_NAME`

if [ ! -z "$response_subnet" ]
then
  gcloud compute networks subnets delete $NETWORK_NAME-subnet --quiet
else
  echo "Subnet $response_subnet doesn't exists, skipped deletion"
fi

#Check whether Cluster Network exists
response_network=`gcloud compute networks list --filter="name=$NETWORK_NAME" --format="value(name)" --project=$PROJECT_NAME`

if [ ! -z "$response_network" ]
then
  gcloud compute networks delete $NETWORK_NAME --quiet
else
  echo "Network $response_network doesn't exists, skipped deletion"
fi
