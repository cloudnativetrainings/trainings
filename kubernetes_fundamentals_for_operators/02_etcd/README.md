# ETCD

In this lab you will learn how to work with etcd.

## Prepare environment

```bash
# connect to one of the master nodes, on which etcdctl is installed
gcloud compute ssh master-0

# export the etcd environment variables for having more convenience
export ETCDCTL_API=3
export ETCDCTL_ENDPOINTS=https://127.0.0.1:2379
export ETCDCTL_CACERT=ca.pem
export ETCDCTL_CERT=kubernetes.pem
export ETCDCTL_KEY=kubernetes-key.pem

# configure kubectl for being allowed to talk to the kubernetes cluster
export KUBECONFIG=~/admin.kubeconfig
```

## Verify setup

```bash
# verify communication to etcd via etcdctl
etcdctl member list

# verify communication to the cluster
kubectl get nodes
```

## Create a ConfigMap

```bash
# create a configmap
kubectl create configmap my-configmap --from-literal foo=bar

# read the configmap via etcdctl
etcdctl get /registry/configmaps/default/my-configmap
```

## Create a Secret

```bash
# create a secret
kubectl create secret generic my-secret --from-literal foo=bar

# read the secret via etcdctl
etcdctl get /registry/secrets/default/my-secret
```

> Note the value of the secret is encrypted.

## Create a snapshot

```bash
# create the snapshot
etcdctl snapshot save snap.db

# verify some metadata of the snapshot
etcdctl --write-out=table snapshot status snap.db
```
