#!/bin/sh

node_sans() {
  node="$1";shift
  gcloud compute instances describe $node \
    --format 'csv(name, 
                  networkInterfaces[0].accessConfigs[0].natIP,
                  networkInterfaces[0].networkIP
                  )[no-heading]'
}

public_ip() {
  gcloud compute addresses describe magicless-ip-address \
    --region $(gcloud config get-value compute/region) \
    --format 'value(address)'
}
