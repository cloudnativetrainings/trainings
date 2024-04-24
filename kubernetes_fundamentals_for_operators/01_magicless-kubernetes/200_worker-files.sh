#!/bin/bash

set -euxo pipefail

# # copy certs
# for node in worker-{0..2}; do
#   gcloud compute scp secrets/ca{,-key}.pem \
#                      secrets/kubernetes{,-key}.pem \
#                      secrets/service-account{,-key}.pem \
#                      ${node}:
# done

# # copy kubeconfigs
# for node in worker-{0..2}; do
#   gcloud compute scp secrets/{admin,kube-controller-manager,kube-scheduler}.kubeconfig \
#                      ${node}:
# done

# # copy service files
# for instance in worker-{0..2}; do
#   gcloud compute scp services/{etcd,kube-apiserver,kube-controller-manager,kube-scheduler}.service ${instance}:
# done

# copy misc config files
for instance in worker-{0..2}; do
  gcloud compute scp configs/10-bridge.conf ${instance}:
  gcloud compute scp configs/kubelet-config.yaml ${instance}:
done

# copy shell scripts
for node in worker-{0..2}; do
  gcloud compute scp 2*.sh ${node}:
done

# copy .trainingrc file
for node in worker-{0..2}; do
  gcloud compute scp ~/.node_trainingrc ${node}:~/.trainingrc
done

# TODO etcd version is not needed on worker nodes .trainingrc
# TODO switch to containerd from docker
