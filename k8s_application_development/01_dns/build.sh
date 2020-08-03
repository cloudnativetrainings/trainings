#!/bin/bash

export APP=curl
export VERSION=0.0.1
export PROJECT_NAME=loodse-training-playground
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/loodse-training
export IMAGE=$CONTAINER_REGISTRY/$APP:$VERSION

docker build -t $IMAGE .
docker push $IMAGE

