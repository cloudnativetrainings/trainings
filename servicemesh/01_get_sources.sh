#!/bin/bash

# variables
export PROJECT_NAME=loodse-training-playground

# clone repo
https://github.com/loodse/k8s-exercises.git

# fix container registry url
find . -type f -name "*.yaml" -exec sed -i "s/loodse-training-playground/$PROJECT_NAME/g" {} +
