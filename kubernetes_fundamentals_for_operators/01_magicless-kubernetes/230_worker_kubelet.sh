#!/bin/false

# this is meant to be run on each worker node

set -euxo pipefail

source ~/.trainingrc

# create folders
sudo mkdir -p /var/lib/kubelet/

# download and install binary
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubelet"
sudo install -o root -m 0755 kubelet /usr/local/bin/

# copy secrets
sudo install -o root -m 0644 ca.pem /var/lib/kubelet/ca.pem
sudo install -o root -m 0644 ${HOSTNAME}.pem /var/lib/kubelet/kubelet.pem
sudo install -o root -m 0600 ${HOSTNAME}-key.pem /var/lib/kubelet/kubelet-key.pem
sudo install -o root -m 0600 ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig

# create kubelet config file
export POD_CIDR=$(curl -s -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/attributes/pod-cidr)
envsubst < kubelet-config.yaml > kubelet-config.yaml.subst
sudo install -o root -m 0644 kubelet-config.yaml.subst /var/lib/kubelet/kubelet-config.yaml

# create kubelet service file
sudo install -o root -m 0644 kubelet.service /etc/systemd/system/kubelet.service

# start kubelet service
sudo systemctl daemon-reload
sudo systemctl enable kubelet
sudo systemctl start kubelet
