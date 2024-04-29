#!/bin/bash

set -euxo pipefail

kubectl apply --kubeconfig secrets/admin.kubeconfig -f configs/kube-apiserver-to-kubelet.yaml
