#!/bin/bash

set -euxo pipefail

for x in {0..2}; do
  gcloud compute routes create k8s-pod-route-192-168-1${x}-0-24 \
    --network magicless-vpc \
    --next-hop-address 10.254.254.20${x} \
    --destination-range 192.168.1${x}.0/24
done

gcloud compute routes list --filter "network: magicless-vpc"
