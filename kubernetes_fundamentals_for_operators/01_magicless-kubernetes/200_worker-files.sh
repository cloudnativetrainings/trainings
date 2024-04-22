#!/bin/bash

set -euxo pipefail

for node in worker-{0..2}; do
	gcloud compute scp secrets/ca.pem \
                     secrets/${node}{,-key}.pem \
                     $node:
done

for node in worker-{0..2}; do
  gcloud compute scp secrets/${node}.kubeconfig \
                     secrets/kube-proxy.kubeconfig \
                     $node:
done

for node in worker-{0..2}; do
  gcloud compute scp 220_worker.sh 230_worker-cni.sh $node:
done
