#!/bin/bash

export COURSE=multistaged-builds
export PROJECT_NAME=ps-workspace
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/loodse-training

docker build -t $CONTAINER_REGISTRY/$COURSE:0.0.1 src/java
#docker push $CONTAINER_REGISTRY/$COURSE:0.0.1
