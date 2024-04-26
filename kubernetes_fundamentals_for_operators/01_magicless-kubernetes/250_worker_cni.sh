#!/bin/false
# this is meant to be run on each worker node

set -euxo pipefail

# create cni config files
export POD_CIDR=$(curl -s -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/attributes/pod-cidr)
envsubst < 10-bridge.conf > 10-bridge.conf.subst
sudo install -D -o root -m 0644 10-bridge.conf.subst /etc/cni/net.d/10-bridge.conf
sudo install -D -o root -m 0644 99-loopback.conf /etc/cni/net.d/99-loopback.conf
