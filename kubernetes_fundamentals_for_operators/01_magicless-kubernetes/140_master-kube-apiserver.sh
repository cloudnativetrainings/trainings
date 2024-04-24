#!/bin/false
# this is meant to be run on each master node

set -euxo pipefail

# create kube-apiserver service file
export INTERNAL_IP=$( curl -s -H "Metadata-Flavor: Google" \
 http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)
envsubst < kube-apiserver.service > kube-apiserver.service.subst
sudo install -o root -m 0644 kube-apiserver.service.subst /etc/systemd/system/kube-apiserver.service

# start kube-apiserver service
sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver
sudo systemctl start kube-apiserver
