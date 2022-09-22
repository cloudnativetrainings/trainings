#!/bin/false
# this is meant to be run on each worker node
# (use tmux sync panes) and git clone https://github.com/USER/REPO.git

set -euxo pipefail

sudo mkdir -p /etc/cni/net.d /opt/cni/bin
cni_ver=v0.8.7
wget -q --show-progress --https-only --timestamping \
  https://github.com/containernetworking/plugins/releases/download/$cni_ver/cni-plugins-linux-amd64-$cni_ver.tgz

sudo tar -xvf cni-plugins-linux-amd64-$cni_ver.tgz -C /opt/cni/bin/

POD_CIDR=$(curl -s -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/attributes/pod-cidr)

cat <<EOF | sudo tee /etc/cni/net.d/10-bridge.conf
{
    "cniVersion": "0.3.1",
    "name": "bridge",
    "type": "bridge",
    "bridge": "cnio0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "ranges": [
          [{"subnet": "${POD_CIDR}"}]
        ],
        "routes": [{"dst": "0.0.0.0/0"}]
    }
}
EOF

cat <<EOF | sudo tee /etc/cni/net.d/99-loopback.conf
{
    "cniVersion": "0.3.1",
    "type": "loopback"
}
EOF
