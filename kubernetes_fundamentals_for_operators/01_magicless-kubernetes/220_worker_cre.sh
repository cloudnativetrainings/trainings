#!/bin/false

# this is meant to be run on each worker node

set -euxo pipefail

source ~/.trainingrc

# download and install runc
wget -q --show-progress --https-only --timestamping \
  "https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.amd64"
sudo install -D -o root -m 0755 runc.amd64 /usr/local/bin/runc

# download and install containerd
wget -q --show-progress --https-only --timestamping \
  "https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz"
sudo tar zxvf containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz -C /usr/local
rm -f containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz

# copy the containterd service config
sudo install -o root -m 0644 containerd.service /etc/systemd/system/containerd.service
sudo install -D -o root -m 0644 containerd-config.toml /etc/containerd/config.toml

# start containerd service
sudo systemctl daemon-reload
sudo systemctl enable containerd
sudo systemctl start containerd

# download and install crictl
wget -q --show-progress --https-only --timestamping \
  "https://github.com/kubernetes-sigs/cri-tools/releases/download/v${CRICTL_VERSION}/crictl-v${CRICTL_VERSION}-linux-amd64.tar.gz"
sudo tar zxvf crictl-v${CRICTL_VERSION}-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-v${CRICTL_VERSION}-linux-amd64.tar.gz

sudo install -o root -m 0644 crictl.yaml /etc/
