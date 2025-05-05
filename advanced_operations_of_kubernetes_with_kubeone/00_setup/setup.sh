#!/bin/bash

## check if authenticated
if [ $(gcloud auth list --filter=status:ACTIVE --format='value(account)' | grep cloud-native.training) ]; then
  echo successfull authenticated!
else
  gcloud auth login
fi
gcloud auth list

echo "-------------------"

PROJECT_COUNT=$(gcloud projects list --format json | jq .[].projectId | tr -d \" | wc -l)
if (( PROJECT_COUNT == 1)); then
  PROJECT_ID=$(gcloud projects list --format json | jq .[].projectId | tr -d \" )
  echo "Using project $PROJECT_ID"
fi
if [[ -z $PROJECT_ID ]]; then
  echo "INPUT: Type PROJECT_ID (student-XX-project):" && read PROJECT_ID
fi
REGION=europe-west4
ZONE=europe-west4-a

set -euxo pipefail

# set gcloud params
gcloud config set project $PROJECT_ID
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# manifest environment variables in $TRAINING_DIR/.trainingrc file
echo "export GCP_PROJECT_ID=$PROJECT_ID" >> $TRAINING_DIR/.trainingrc
echo "export GCP_REGION=$REGION" >> $TRAINING_DIR/.trainingrc
echo "export GCP_ZONE=$ZONE" >> $TRAINING_DIR/.trainingrc

# email, e.g.: student-00.bechtle@cloud-native.training
echo "export TRAINING_EMAIL=$(echo $GCP_PROJECT_ID | sed 's/\(student-[0-9][0-9]\)-/\1./')@cloud-native.training" >> $TRAINING_DIR/.trainingrc
. $TRAINING_DIR/.trainingrc
