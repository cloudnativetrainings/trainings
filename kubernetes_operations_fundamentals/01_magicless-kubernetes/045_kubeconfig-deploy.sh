#!/bin/bash

set -euxo pipefail

for node in worker-{0..2}; do
  gcloud compute scp secrets/${node}.kubeconfig \
                     secrets/kube-proxy.kubeconfig \
                     $node:
done

for node in master-{0..2}; do
  gcloud compute scp secrets/{admin,kube-controller-manager,kube-scheduler}.kubeconfig \
                     ${node}:
done
