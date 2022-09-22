#!/bin/bash

set -euxo pipefail

# create the vpc
gcloud compute networks create magicless-vpc --subnet-mode custom

# create the subnet
gcloud compute networks subnets create magicless-subnet \
  --network magicless-vpc \
  --range 10.254.254.0/24

# allow all internal traffic
gcloud compute firewall-rules create magicless-internal \
  --action allow --rules all \
  --network magicless-vpc \
  --source-ranges 10.254.254.0/24,192.168.0.0/16

# allow traffic from outside
gcloud compute firewall-rules create magicless-inbound \
  --allow tcp:22,tcp:6443,icmp \
  --network magicless-vpc \
  --source-ranges 0.0.0.0/0

# and let's have one static ip
gcloud compute addresses create magicless-ip-address \
  --region $(gcloud config get-value compute/region)

# print out the static ip  
gcloud compute addresses list --filter="name=('magicless-ip-address')"
