#!/bin/bash

TRAINING_RC_FILE=~/.trainingrc

PROJECT_COUNT=$(gcloud projects list --format json | jq .[].name | tr -d \" | wc -l)
if (( PROJECT_COUNT == 1)); then
  PROJECT_NAME=$(gcloud projects list --format json | jq .[].name | tr -d \" )
  echo "Using project $PROJECT_NAME"
fi
if [[ -z $PROJECT_NAME ]]; then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
export REGION=europe-west3
export ZONE=europe-west3-a

set -euxo pipefail

rm -rf $TRAINING_RC_FILE
grep -qxF "source $TRAINING_RC_FILE" ~/.bashrc || echo "source $TRAINING_RC_FILE" >> ~/.bashrc

# gcloud params
grep -qxF "export REGION=europe-west3" $TRAINING_RC_FILE || echo "export REGION=europe-west3" >> $TRAINING_RC_FILE
grep -qxF "export ZONE=europe-west3-a" $TRAINING_RC_FILE || echo "export ZONE=europe-west3-a" >> $TRAINING_RC_FILE
grep -qxF "export PROJECT_NAME=$PROJECT_NAME" $TRAINING_RC_FILE || echo "export PROJECT_NAME=$PROJECT_NAME" >> $TRAINING_RC_FILE

grep -qxF "gcloud config set project $PROJECT_NAME" $TRAINING_RC_FILE || echo "gcloud config set project $PROJECT_NAME" >> $TRAINING_RC_FILE
grep -qxF "gcloud config set compute/region $REGION" $TRAINING_RC_FILE || echo "gcloud config set compute/region $REGION" >> $TRAINING_RC_FILE
grep -qxF "gcloud config set compute/zone $ZONE" $TRAINING_RC_FILE || echo "gcloud config set compute/zone $ZONE" >> $TRAINING_RC_FILE

# echo "export ETCDCTL_API=3" >> /root/.bashrc
# echo "export ETCDCTL_ENDPOINTS=https://127.0.0.1:2379" >> /root/.bashrc
# echo "export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt" >> /root/.bashrc
# echo "export ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key" >> /root/.bashrc
# echo "export ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt" >> /root/.bashrc

# ETCDCTL_API=3 etcdctl member list \
#   --endpoints=https://127.0.0.1:2379 \
#   --cacert=/etc/etcd/ca.pem \
#   --cert=/etc/etcd/kubernetes.pem \
#   --key=/etc/etcd/kubernetes-key.pem