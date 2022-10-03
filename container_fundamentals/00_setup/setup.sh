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
export TRAINING_NAME=training-cf
export VM_NAME=$TRAINING_NAME
export NETWORK_NAME=$TRAINING_NAME
export FIREWALL_NAME=$TRAINING_NAME

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

#create subnet
response_subnet=`gcloud compute networks subnets list --filter="name=$NETWORK_NAME-subnet" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_subnet" ]
then
  gcloud compute networks subnets create $NETWORK_NAME-subnet --project=$PROJECT_NAME \
    --range=10.0.0.0/24 --network=$NETWORK_NAME --region=$REGION
else
      echo "Subnet $response_subnet already exists, skip creation"
fi

# create VM
response_instance=`gcloud compute instances list --filter="name=$VM_NAME" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_instance" ]
then
  gcloud beta compute --project=$PROJECT_NAME instances create $VM_NAME \
    --zone=$ZONE --machine-type=n2-standard-2 \
    --subnet=$NETWORK_NAME-subnet --network-tier=PREMIUM \
    --maintenance-policy=MIGRATE \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --tags=http-server,https-server \
    --image=ubuntu-2204-jammy-v20220924 --image-project=ubuntu-os-cloud \
    --boot-disk-size=100GB --boot-disk-type=pd-standard --boot-disk-device-name=container-training \
    --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
else
      echo "Instance $response_instance already exists, skip creation"
fi

# create firewall rules
response_firewall_http=`gcloud compute firewall-rules list --filter="$FIREWALL_NAME-allow-http" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_firewall_http" ]
then
  gcloud compute --project=$PROJECT_NAME firewall-rules create $FIREWALL_NAME-allow-http \
    --direction=INGRESS --priority=1000 --network=$NETWORK_NAME --action=ALLOW \
    --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
else
      echo "Firewall $response_firewall_http already exists, skip creation"
fi

response_firewall_https=`gcloud compute firewall-rules list --filter="$FIREWALL_NAME-allow-https" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_firewall_https" ]
then
  gcloud compute --project=$PROJECT_NAME firewall-rules create $FIREWALL_NAME-allow-https \
    --direction=INGRESS --priority=1000 --network=$NETWORK_NAME --action=ALLOW \
    --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server
else
      echo "Firewall $response_firewall_https already exists, skip creation"
fi

response_firewall_ssh=`gcloud compute firewall-rules list --filter="$FIREWALL_NAME-allow-ssh" --format="value(name)" --project=$PROJECT_NAME`

if [ -z "$response_firewall_ssh" ]
then
  gcloud compute --project=$PROJECT_NAME firewall-rules create $FIREWALL_NAME-allow-ssh \
    --direction=INGRESS --priority=1000 --network=$NETWORK_NAME --action=ALLOW \
    --rules=tcp:22 --source-ranges=0.0.0.0/0
else
      echo "Firewall $response_firewall_ssh already exists, skip creation"
fi

# wait until the vm is up
while true; do
  gcloud compute ssh --quiet root@$VM_NAME --zone=$ZONE --project=$PROJECT_NAME --command="true" 2> /dev/null
  if [ $? == 0 ]; then
    echo "$VM_NAME is UP and RUNNING!.."
    break
  else
    echo "$VM_NAME is not ready yet, will try again in 5 seconds..."
    sleep 5
  fi
done

# install additional tools
gcloud compute ssh root@$VM_NAME --zone=$ZONE --project=$PROJECT_NAME \
  --command="apt-get update && apt-get install -y skopeo jq && wget https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.deb && sudo apt install ./dive_0.10.0_linux_amd64.deb"

gcloud compute ssh root@$VM_NAME --zone=$ZONE --project=$PROJECT_NAME \
  --command="git clone https://github.com/kubermatic-labs/trainings.git && echo 'cd ~/trainings/container_fundamentals' >> ~/.bashrc"
