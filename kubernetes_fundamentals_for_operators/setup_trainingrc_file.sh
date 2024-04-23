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

# versions
grep -qxF "export ETCD_VERSION=$ETCD_VERSION" $TRAINING_RC_FILE || echo "export ETCD_VERSION=$ETCD_VERSION" >> $TRAINING_RC_FILE
grep -qxF "export KUBERNETES_VERSION=$KUBERNETES_VERSION" $TRAINING_RC_FILE || echo "export KUBERNETES_VERSION=$KUBERNETES_VERSION" >> $TRAINING_RC_FILE

