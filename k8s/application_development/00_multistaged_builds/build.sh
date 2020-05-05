#!/bin/bash

export APP=multistaged-builds
export VERSION=0.0.1
export PROJECT_NAME=ps-workspace
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/loodse-training
export IMAGE=$CONTAINER_REGISTRY/$APP:$VERSION

# TODO inject build version and app name

docker build -t $IMAGE src/java
docker push $IMAGE
#docker run -it --rm -p 8080:8080 $IMAGE

