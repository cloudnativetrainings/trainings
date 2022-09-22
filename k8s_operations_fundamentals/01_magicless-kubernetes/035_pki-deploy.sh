#!/bin/bash

set -euxo pipefail

# fortunately gcloud util can help with deploying to the nodes:
for node in worker-{0..2}; do
	gcloud compute scp secrets/ca.pem \
                     secrets/${node}{,-key}.pem \
                     $node:
done

for node in master-{0..2}; do
  gcloud compute scp secrets/ca{,-key}.pem \
                     secrets/kubernetes{,-key}.pem \
                     secrets/service-account{,-key}.pem \
                     ${node}:
done
