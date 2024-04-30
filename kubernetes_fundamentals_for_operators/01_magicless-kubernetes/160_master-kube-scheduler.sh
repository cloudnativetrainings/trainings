#!/bin/false

# this is meant to be run on each master node

set -euxo pipefail

source ~/.trainingrc

# create kube-scheduler service file
sudo install -o root -m 0644 kube-scheduler.service /etc/systemd/system/kube-scheduler.service

# copy the kube-scheduler config
sudo install -D -o root -m 0644 kube-scheduler.yaml /etc/kubernetes/config/kube-scheduler.yaml

# start kube-scheduler service
sudo systemctl daemon-reload
sudo systemctl enable kube-scheduler
sudo systemctl start kube-scheduler
