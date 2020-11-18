#!/bin/bash

# variables
if [[ -z ${PROJECT_NAME} ]]
then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi

set -euxo pipefail

# fix container registry url
find ./.. -type f -name "*.yaml" -exec sed -i "s/loodse-training-playground/$PROJECT_NAME/g" {} +
find ./.. -type f -name "build_*.sh" -exec sed -i "s/PROJECT_NAME=loodse-training-playground/PROJECT_NAME=$PROJECT_NAME/g" {} +
