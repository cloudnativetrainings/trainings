#!/bin/bash

if [[ -z ${PROJECT_NAME} ]]
then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
export REGION=europe-west3
export ZONE=europe-west3-a
export VM_NAME=loodse-training
export FIREWALL_NAME=$VM_NAME

gcloud beta compute --project=$PROJECT_NAME instances create $VM_NAME \
  --zone=$ZONE --machine-type=n1-standard-2 \
  --subnet=default --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --service-account=1011882185659-compute@developer.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
  --tags=http-server \
  --image=ubuntu-2004-focal-v20200729 --image-project=ubuntu-os-cloud \
  --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=container-training \
  --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud compute --project=$PROJECT_NAME firewall-rules create $FIREWALL_NAME \
  --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 \
  --source-ranges=0.0.0.0/0 --target-tags=http-server