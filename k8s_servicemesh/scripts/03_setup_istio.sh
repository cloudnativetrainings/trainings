#!/bin/bash

# install istioctl 
# curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.4.3 sh -
# mv istio-1.4.3 ~
# curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.5.6 sh -
# mv istio-1.5.6 ~
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.6.3 sh -
mv istio-1.6.3 ~
sudo cp ~/istio-1.6.3/bin/istioctl /usr/local/bin
