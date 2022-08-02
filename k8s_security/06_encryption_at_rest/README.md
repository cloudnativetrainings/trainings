
# inspect etcd
cat /etc/kubernetes/manifests/etcd.yaml 
ls -alh /var/lib/etcd/

# check secret is in plain text

kubectl create secret generic my-secret --from-literal password=password123

etcdctl get /registry/secrets/default/my-secret

# implement encryption at rest

# customize encryption-provider-config

take a look at encryption config => PW and resource types

cp /root/lines-of-defence/tasks/06_encryption_at_rest/encryption-config.yaml /root/apiserver

```
- --encryption-provider-config=/apiserver/encryption-config.yaml
```
=> crictl ps

# check encryption => expected fail

etcdctl get /registry/secrets/default/my-secret

kubectl create secret generic my-secret-2 --from-literal password2=password456

etcdctl get /registry/secrets/default/my-secret-2

# encrypt all existing secrets
kubectl get secrets --all-namespaces -o json | kubectl replace -f -

etcdctl get /registry/secrets/default/my-secret
