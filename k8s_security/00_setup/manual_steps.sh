#!/bin/bash

export IP=$(curl https://ipinfo.io/ip)
export API_SERVER=https://$IP:6443
PS1="$ "
export ETCDCTL_API=3
export ETCDCTL_ENDPOINTS=https://127.0.0.1:2379
export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
export ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key
export ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt
kubectl apply -f /root/lines-of-defence/tasks/pod.yaml
kubectl create clusterrolebinding my-suboptimal-clusterrolebinding --clusterrole=cluster-admin --serviceaccount default:default
