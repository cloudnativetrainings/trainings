#!/bin/bash

set -euxo pipefail

# machines
gcloud -q compute instances delete \
  controller-0 controller-1 controller-2 \
  worker-0 worker-1 worker-2

# networking
gcloud -q compute addresses delete magicless-ip-address

# firewall
gcloud -q compute firewall-rules delete \
  magicless-internal \
  magicless-inbound

# routes if created
for x in {0..2}; do
  gcloud compute routes delete -q k8s-pod-route-192-168-1${x}-0-24
done

# networks
gcloud -q compute networks subnets delete magicless-subnet
gcloud -q compute networks delete magicless-vpc

