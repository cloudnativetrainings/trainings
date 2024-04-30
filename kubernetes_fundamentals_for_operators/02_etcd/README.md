
# Create a ConfigMap

export KUBECONFIG=~/admin.kubeconfig

ensure etcdctl working

show envvars

```bash
kubectl create configmap my-configmap --from-literal foo=bar
```

# Read the ConfigMap

```bash
etcdctl get /registry/configmaps/default/my-configmap
```

# Create a secret

```bash
kubectl create secret generic my-secret --from-literal foo=bar
```

# Read the secret

```bash
etcdctl get /registry/secrets/default/my-secret
```

# Create a snapshot

```bash
etcdctl snapshot save snap.db
```

# Check the snapshot

```bash
etcdctl --write-out=table snapshot status snap.db
```
