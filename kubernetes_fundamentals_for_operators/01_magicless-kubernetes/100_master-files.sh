#!/bin/bash

set -euxo pipefail

source ~/.trainingrc

# copy secrets
for node in master-{0..2}; do
  gcloud compute scp secrets/ca{,-key}.pem \
                     secrets/kubernetes{,-key}.pem \
                     secrets/service-account{,-key}.pem \
                     secrets/encryption-config.yaml \
                     secrets/{admin,kube-controller-manager,kube-scheduler}.kubeconfig \
                     ${node}:
done

# copy config files
for node in master-{0..2}; do
  gcloud compute scp services/{etcd,kube-apiserver,kube-controller-manager,kube-scheduler}.service ${node}:
  gcloud compute scp configs/kube-scheduler.yaml configs/kube-apiserver-to-kubelet.yaml ${node}:
done

# copy shell scripts
for node in master-{0..2}; do
  gcloud compute scp 1*.sh ${node}:
done

# copy .trainingrc file
for node in master-{0..2}; do
  gcloud compute scp ~/.node_trainingrc ${node}:~/.trainingrc
done
