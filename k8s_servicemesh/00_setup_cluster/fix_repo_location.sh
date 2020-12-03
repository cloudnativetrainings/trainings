#!/bin/bash

PROJECT_COUNT=$(gcloud projects list --format json | jq .[].name | tr -d \" | wc -l)
if (( PROJECT_COUNT == 1)); then
  PROJECT_NAME=$(gcloud projects list --format json | jq .[].name | tr -d \" )
  echo "Using project $PROJECT_NAME"
fi
if [[ -z $PROJECT_NAME ]]; then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi

set -euxo pipefail

# fix paths
find ./.. -type f -name "*.yaml" -exec sed -i "s/loodse-training-playground/$PROJECT_NAME/g" {} +
find ./.. -type f -name "build_*.sh" -exec sed -i "s/PROJECT_NAME=loodse-training-playground/PROJECT_NAME=$PROJECT_NAME/g" {} +
