# Create a secret

```bash
kubectl create secret generic my-secret --from-literal foo=bar
```

# Read the secret

```bash
ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379  \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem \
  get /registry/secrets/default/my-secret
```