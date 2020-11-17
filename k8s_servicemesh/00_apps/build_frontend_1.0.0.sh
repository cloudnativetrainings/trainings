#!/bin/bash

export APP=frontend
export VERSION=1.0.0
export PROJECT_NAME=loodse-training-playground
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/kubernetes-servicemesh
export IMAGE=$CONTAINER_REGISTRY/$APP:$VERSION

docker build -t $IMAGE ./frontend --build-arg BUILD_VERSION=$VERSION
docker push $IMAGE
