# Encryption at Rest

## Communication with etcd

```bash
# verify etcdctl is installed
etcdctl version

# verify etcd configuration
env | grep ETCD

# note that most of those values are taken from the etcd configuration
cat /etc/kubernetes/manifests/etcd.yaml 
```

## Get a secret from etcd

```bash
# create a secret (if it does not exist yet)
kubectl create secret generic my-secret --from-literal password=password123

# get the secret directly from etcd - note that it is in plain text
etcdctl get /registry/secrets/default/my-secret
```

## Engage Encryption at Rest

```bash
# inspect the encryption config
cat /root/06_encryption_at_rest/encryption-config.yaml

# copy the encryption config file into the folder `/root/apiserver`
cp /root/06_encryption_at_rest/encryption-config.yaml /root/apiserver
```

### Engage the Encryption Config File in the API Server

Edit the static manifest for the API Server
```bash
vi /etc/kubernetes/manifests/kube-apiserver.yaml
```

```yaml
...
spec:
  containers:
  - command:
    - kube-apiserver
    - --encryption-provider-config=/apiserver/encryption-config.yaml # <= add this line
...
```

Note that the kubelet is restarting the apiserver due to we changed the pod in the static pod manifests. This will take ~ 2 minutes. The Kubernetes Cluster is not reachable until the apiserver has been restarted. You can check the progress via `crictl ps`.

## Verify Encryption

### New Secrets

```bash
# create a new secret
kubectl create secret generic my-secret-2 --from-literal password2=password456

# verify the new secret is encrypted
etcdctl get /registry/secrets/default/my-secret-2
```

### Old Secrets

```bash
# create a new secret - note the secret is not encrypted
etcdctl get /registry/secrets/default/my-secret

# re-create all secrets in the cluster
kubectl get secrets --all-namespaces -o json | kubectl replace -f -

# verify the secret is now encrypted
etcdctl get /registry/secrets/default/my-secret
```
