
# setup

cp 12_auditing/my-policy.yaml /root/apiserver/

vi /etc/kubernetes/manifests/kube-apiserver.yaml
=> in apiserver
```bash
- --audit-policy-file=/apiserver/my-policy.yaml
- --audit-log-path=/apiserver/default-secrets.log
- --audit-log-maxage=10
- --audit-log-maxsize=100
```

crictl ps

# use it

cat /root/apiserver/default-secrets.log 

<!-- TODO name clash -->
kubectl create secret generic my-secret-3 --from-literal foo=bar
cat /root/apiserver/default-secrets.log 

kubectl get secrets
cat /root/apiserver/default-secrets.log 

kubectl get secret my-secret
cat /root/apiserver/default-secrets.log 

