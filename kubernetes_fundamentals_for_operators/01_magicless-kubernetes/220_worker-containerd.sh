#!/bin/false
# this is meant to be run on each master node

set -euxo pipefail

sudo apt-get -y install socat conntrack ipset

swapoff -a

# TODO containerd version
sudo apt-get install -y containerd


mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd
apt-mark hold containerd

crictl
containerd
runc