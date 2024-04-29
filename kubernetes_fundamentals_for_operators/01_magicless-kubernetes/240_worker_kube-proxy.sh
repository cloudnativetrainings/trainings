#!/bin/false
# this is meant to be run on each worker node

set -euxo pipefail

# download and install binary
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kube-proxy"
sudo install -o root -m 0755 kube-proxy /usr/local/bin/

# copy secrets
sudo install -D -o root -m 0600 kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig

# create kube-proxy config file
sudo install -D -o root -m 0644 kube-proxy-config.yaml /var/lib/kube-proxy/kube-proxy-config.yaml

# create kube-proxy service file
sudo install -o root -m 0644 kube-proxy.service /etc/systemd/system/kube-proxy.service

# start kubelet service
sudo systemctl daemon-reload
sudo systemctl enable kube-proxy
sudo systemctl start kube-proxy
