#!/bin/bash

set -euxo pipefail

helm upgrade --install --create-namespace --namespace logging --wait \
  --values ./values.yaml elasticsearch charts/logging/elasticsearch 

helm upgrade --install --create-namespace --namespace logging --wait \
  --values ./values.yaml fluentbit charts/logging/fluentbit

helm upgrade --install --create-namespace --namespace logging --wait \
  --values ./values.yaml kibana charts/logging/kibana

