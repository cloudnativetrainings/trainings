#!/bin/bash

export APP=app
export VERSION=0.0.1
export PROJECT_NAME=loodse-training-playground
export CONTAINER_REGISTRY=eu.gcr.io/$PROJECT_NAME/loodse-training
export IMAGE=$CONTAINER_REGISTRY/$APP:$VERSION

# build application
#./gradlew clean build

# run application
#java -jar build/libs/app-0.0.1.jar

# containerize application
docker build -t $IMAGE . --build-arg BUILD_VERSION=$VERSION
docker push $IMAGE

