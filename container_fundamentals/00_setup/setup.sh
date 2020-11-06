#!/bin/bash

if [[ -z ${PROJECT_NAME} ]]
then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
export REGION=europe-west3
export ZONE=europe-west3-a
export TRAINING_NAME=container-fundamentals
export VM_NAME=$TRAINING_NAME
export NETWORK_NAME=$TRAINING_NAME
export FIREWALL_NAME=$TRAINING_NAME

set -euxo pipefail

# create networks
gcloud compute networks create $NETWORK_NAME --project=$PROJECT_NAME \
  --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
gcloud compute networks subnets create $NETWORK_NAME-subnet --project=$PROJECT_NAME \
  --range=10.0.0.0/24 --network=$NETWORK_NAME --region=$REGION

# create VM
gcloud beta compute --project=$PROJECT_NAME instances create $VM_NAME \
  --zone=$ZONE --machine-type=n2-standard-2 \
  --subnet=$NETWORK_NAME-subnet --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
  --tags=http-server,https-server \
  --image=ubuntu-2004-focal-v20201028 --image-project=ubuntu-os-cloud \
  --boot-disk-size=100GB --boot-disk-type=pd-standard --boot-disk-device-name=container-training \
  --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

# create firewall rules
gcloud compute --project=$PROJECT_NAME firewall-rules create $FIREWALL_NAME-allow-http \
  --direction=INGRESS --priority=1000 --network=$NETWORK_NAME --action=ALLOW \
  --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute --project=$PROJECT_NAME firewall-rules create $FIREWALL_NAME-allow-https \
  --direction=INGRESS --priority=1000 --network=$NETWORK_NAME --action=ALLOW \
  --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server
gcloud compute --project=$PROJECT_NAME firewall-rules create $FIREWALL_NAME-allow-ssh \
  --direction=INGRESS --priority=1000 --network=$NETWORK_NAME --action=ALLOW \
  --rules=tcp:22 --source-ranges=0.0.0.0/0