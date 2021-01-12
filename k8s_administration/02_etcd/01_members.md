# Printout all members of the etcd cluster

```bash
ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379  \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem \
  member list
```