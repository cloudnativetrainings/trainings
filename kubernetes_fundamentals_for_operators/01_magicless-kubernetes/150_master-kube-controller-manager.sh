#!/bin/false

# this is meant to be run on each master node

set -euxo pipefail

source ~/.trainingrc

# create kube-apiserver service file
sudo install -o root -m 0644 kube-controller-manager.service /etc/systemd/system/kube-controller-manager.service

# start kube-controller-manager service
sudo systemctl daemon-reload
sudo systemctl enable kube-controller-manager
sudo systemctl start kube-controller-manager
