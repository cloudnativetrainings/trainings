#!/bin/bash

PROJECT_COUNT=$(gcloud projects list --format json | jq .[].name | tr -d \" | wc -l)
if (( PROJECT_COUNT == 1)); then
  PROJECT_NAME=$(gcloud projects list --format json | jq .[].name | tr -d \" )
  echo "Using project $PROJECT_NAME"
fi
if [[ -z $PROJECT_NAME ]]; then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
export APP=frontend
export VERSION=1.0.0
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/kubernetes-servicemesh
export IMAGE=$CONTAINER_REGISTRY/$APP:$VERSION

set -euxo pipefail

docker build -t $IMAGE ./frontend --build-arg BUILD_VERSION=$VERSION
docker push $IMAGE
