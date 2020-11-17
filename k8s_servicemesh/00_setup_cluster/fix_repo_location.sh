#!/bin/bash

set -euxo pipefail

# variables
export PROJECT_NAME=loodse-training-playground

# fix container registry url
find ./.. -type f -name "*.yaml" -exec sed -i "s/loodse-training-playground/$PROJECT_NAME/g" {} +
