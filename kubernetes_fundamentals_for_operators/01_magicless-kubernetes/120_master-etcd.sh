#!/bin/false

# this is meant to be run on each master node

set -euxo pipefail

source ~/.trainingrc

# install etcd
wget -q --show-progress --https-only --timestamping \
  "https://github.com/coreos/etcd/releases/download/v$ETCD_VERSION/etcd-v$ETCD_VERSION-linux-amd64.tar.gz"
tar -xvf etcd-v$ETCD_VERSION-linux-amd64.tar.gz
sudo install -o root -m 0755 etcd-v$ETCD_VERSION-linux-amd64/etcd* /usr/local/bin

# copy etcd certs
sudo install -d -o root -m 0644 ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

# create etcd service file
export INTERNAL_IP=$( curl -s -H "Metadata-Flavor: Google" \
 http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)
export ETCD_NAME=$(hostname -s)
envsubst < etcd.service > etcd.service.subst
sudo install -o root -m 0644 etcd.service.subst /etc/systemd/system/etcd.service

# start etcd service
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd

# verify
ETCDCTL_API=3 etcdctl member list \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem