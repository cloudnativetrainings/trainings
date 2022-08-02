
# setup

cp 12_auditing/audit-policy.yaml /root/apiserver/

=> in apiserver
```bash
- --audit-policy-file=/apiserver/audit-policy.yaml
- --audit-log-path=/apiserver/default-secrets.log
- --audit-log-maxage=10
- --audit-log-maxsize=100
```

# use it

cat /root/apiserver/default-secrets.log 

kubectl create secret generic my-secret --from-literal foo=bar
cat /root/apiserver/default-secrets.log 

kubectl get secrets
cat /root/apiserver/default-secrets.log 

kubectl get secret my-secret
cat /root/apiserver/default-secrets.log 

