#!/bin/bash

set -euxo pipefail

source ~/.trainingrc

kubectl apply --kubeconfig secrets/admin.kubeconfig -f configs/kube-apiserver-to-kubelet.yaml
