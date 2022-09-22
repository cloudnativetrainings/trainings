#!/bin/bash

set -euxo pipefail

# variables
export ISTIO_VERSION=1.11.2

# install istioctl 
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
sudo cp ./istio-$ISTIO_VERSION/bin/istioctl /usr/local/bin
rm -rf ./istio-$ISTIO_VERSION
