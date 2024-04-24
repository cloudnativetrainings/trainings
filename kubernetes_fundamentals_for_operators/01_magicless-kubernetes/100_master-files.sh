#!/bin/bash

set -euxo pipefail

# copy certs
for node in master-{0..2}; do
  gcloud compute scp secrets/ca{,-key}.pem \
                     secrets/kubernetes{,-key}.pem \
                     secrets/service-account{,-key}.pem \
                     ${node}:
done

# copy kubeconfigs
for node in master-{0..2}; do
  gcloud compute scp secrets/{admin,kube-controller-manager,kube-scheduler}.kubeconfig \
                     ${node}:
done

# copy encryption config
for instance in master-{0..2}; do
  gcloud compute scp secrets/encryption-config.yaml ${instance}:
done

# copy service files
for instance in master-{0..2}; do
  gcloud compute scp services/{etcd,kube-apiserver,kube-controller-manager,kube-scheduler}.service ${instance}:
done

# copy misc config files
for instance in master-{0..2}; do
  gcloud compute scp configs/kube-scheduler.yaml ${instance}:
  gcloud compute scp configs/kube-apiserver-to-kubelet.yaml ${instance}:
done

# copy shell scripts
for node in master-{0..2}; do
  gcloud compute scp 1*.sh ${node}:
done

# copy .trainingrc file
for node in master-{0..2}; do
  gcloud compute scp ~/.node_trainingrc ${node}:~/.trainingrc
done
