#!/bin/bash

# install istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.4.3 sh -
mv istio-1.4.3 ~
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.5.6 sh -
mv istio-1.5.6 ~
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.6.3 sh -
mv istio-1.6.3 ~
mv ~/istio-1.6.3/bin/istioctl /usr/local/bin

# install istio into cluster
istioctl manifest apply --set profile=demo
# istioctl manifest generate --set profile=demo > generated-manifest.yaml
# istioctl verify-install -f generated-manifest.yaml

# enable injection 
kubectl label namespace default istio-injection=enabled
kubectl get namespace -L istio-injection