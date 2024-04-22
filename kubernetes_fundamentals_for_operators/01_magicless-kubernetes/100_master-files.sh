#!/bin/bash

set -euxo pipefail

for node in master-{0..2}; do
  gcloud compute scp secrets/ca{,-key}.pem \
                     secrets/kubernetes{,-key}.pem \
                     secrets/service-account{,-key}.pem \
                     ${node}:
done

for node in master-{0..2}; do
  gcloud compute scp secrets/{admin,kube-controller-manager,kube-scheduler}.kubeconfig \
                     ${node}:
done

for instance in master-{0..2}; do
  gcloud compute scp secrets/encryption-config.yaml ${instance}:
done

for instance in master-{0..2}; do
  gcloud compute scp services/{etcd,kube-apiserver,kube-controller-manager,kube-scheduler}.service ${instance}:
done

for node in master-{0..2}; do
  gcloud compute scp 120_master-etcd.sh 130_master.sh ${node}:
done

