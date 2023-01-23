#!/bin/bash

## check if authenticated
if [ $(gcloud auth list --filter=status:ACTIVE --format='value(account)' | grep loodse.training) ]; then
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
export REGION=europe-west4
export ZONE=europe-west4-a

set -euxo pipefail

# set gcloud params
gcloud config set project $PROJECT_ID
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE