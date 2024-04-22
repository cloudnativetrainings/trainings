#!/bin/bash

set -euxo pipefail

kubectl --kubeconfig secrets/admin.kubeconfig create secret generic "magicless" \
  --from-literal="mykey=mydata"

# print hexdump etcd value
gcloud compute ssh master-0 \
  --command \
    "sudo ETCDCTL_API=3 etcdctl get \
      --endpoints=https://127.0.0.1:2379 \
      --cacert=/etc/etcd/ca.pem \
      --cert=/etc/etcd/kubernetes.pem \
      --key=/etc/etcd/kubernetes-key.pem\
      /registry/secrets/default/magicless | hexdump -C"
      