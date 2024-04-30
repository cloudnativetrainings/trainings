#!/bin/bash

set -euxo pipefail

source ~/.trainingrc

# copy secrets
for node in worker-{0..2}; do
  gcloud compute scp secrets/${node}.pem \
                     secrets/${node}-key.pem \
                     secrets/${node}.kubeconfig \
                     secrets/kube-proxy.kubeconfig \
                     secrets/ca.pem \
                     ${node}:
done                     

# copy config files
for node in worker-{0..2}; do
  gcloud compute scp configs/10-bridge.conf \
                     configs/99-loopback.conf \
                     configs/containerd-config.toml \
                     configs/crictl.yaml \
                     configs/kube-proxy-config.yaml \
                     configs/kubelet-config.yaml \
                     services/containerd.service \
                     services/kube-proxy.service \
                     services/kubelet.service \
                     ${node}:
done

# copy shell scripts
for node in worker-{0..2}; do
  gcloud compute scp 2*.sh ${node}:
done

# copy .trainingrc file
for node in worker-{0..2}; do
    gcloud compute scp ~/.node_trainingrc ${node}:~/.trainingrc
done
