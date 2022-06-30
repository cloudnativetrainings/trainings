#!/bin/bash

set -euxo pipefail

helm upgrade --install --create-namespace --namespace iap --wait \
  --values ./values.yaml iap charts/iap

kubectl create secret generic ca-key-pair \
    -n iap \
    --from-file=tls.crt=pki/ca.crt \
    --from-file=tls.key=pki/ca.key
