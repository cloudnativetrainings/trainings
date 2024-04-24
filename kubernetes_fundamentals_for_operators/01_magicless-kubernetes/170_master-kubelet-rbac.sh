#!/bin/false
# this is meant to be run on each master node

set -euxo pipefail

# download binaries
kubectl apply --kubeconfig admin.kubeconfig -f kube-apiserver-to-kubelet.yaml

