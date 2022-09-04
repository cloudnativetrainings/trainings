
# Kubernetes Auditing

## Engage Auditing

```bash
# inspect the auditing policy
vi 12_auditing/my-policy.yaml

# copy the policy file into the apiserver mount
cp 12_auditing/my-policy.yaml /root/apiserver/
```

### Enable Auditing in the API Server

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
    - --audit-policy-file=/apiserver/my-policy.yaml # <= add this line
    - --audit-log-path=/apiserver/default-secrets.log # <= add this line
    - --audit-log-maxage=10 # <= add this line
    - --audit-log-maxsize=100 # <= add this line
...
```

Note that the kubelet is restarting the apiserver due to we changed the pod in the static pod manifests. This will take ~ 2 minutes. The Kubernetes Cluster is not reachable until the apiserver has been restarted. You can check the progress via `crictl ps`.


## Verify Auditing

```bash
# check the logfile - there should be no content in this file
cat /root/apiserver/default-secrets.log 

# get secrets from the default namespace
kubectl get secrets

# check the logfile - now the previous request for secrets should have triggered an entry
cat /root/apiserver/default-secrets.log | jq
```
