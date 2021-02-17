#!/bin/false
# this is meant to be run on each master node
# (use tmux sync panes) and git clone https://github.com/USER/REPO.git

set -euxo pipefail

etcd_ver=3.4.13

wget -q --show-progress --https-only --timestamping \
  "https://github.com/coreos/etcd/releases/download/v$etcd_ver/etcd-v$etcd_ver-linux-amd64.tar.gz"

tar -xvf etcd-v$etcd_ver-linux-amd64.tar.gz
sudo install -o 0:0 -m 0755 etcd-v$etcd_ver-linux-amd64/etcd* /usr/local/bin

sudo mkdir -p /etc/etcd /var/lib/etcd
sudo install -o 0:0 -m 0644 ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

INTERNAL_IP=$( curl -s -H "Metadata-Flavor: Google" \
 http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)

ETCD_NAME=$(hostname -s)

cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster master-0=https://10.254.254.100:2380,master-1=https://10.254.254.101:2380,master-2=https://10.254.254.102:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd

ETCDCTL_API=3 etcdctl member list \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem
