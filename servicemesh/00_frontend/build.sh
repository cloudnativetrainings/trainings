#!/bin/bash

export APP=frontend
export VERSION=2.0.0
export PROJECT_NAME=loodse-training-playground
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/loodse-training
export IMAGE=$CONTAINER_REGISTRY/$APP:$VERSION

docker build -t $IMAGE . --build-arg BUILD_VERSION=$VERSION
docker push $IMAGE

