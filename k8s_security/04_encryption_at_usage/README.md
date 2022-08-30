# Encryption at Usage

## Create a Secret

```bash
kubectl create secret generic my-secret --from-literal password=password123
```

## Decode the Secret

```bash
# the secret is in plain text
kubectl get secret my-secret -o jsonpath='{.data.password}' | base64 -d
```

## Secret in Pod

### Enable the secret within the Pod via the file `pod.yaml`

```yaml
...
volumeMounts:
  - name: secret-data
    mountPath: /secret/
    readOnly: true
...
volumes:
  - name: secret-data
    secret:
      secretName: my-secret
...
```

### Apply the Pod

```bash
kubectl apply -f pod.yaml --force
```

### Show the Secret in plain text

```bash
kubectl exec -it my-suboptimal-pod -- cat /secret/password
```

## Secret on host level

```bash
# check the temp file systems on host level
df | grep tmpfs

# printout the sensitive data in plain text
# eg cat /var/lib/kubelet/pods/c61079ab-eed7-4f79-b87b-b01c62e54d70/volumes/kubernetes.io~secret/secret-data/password
cat /var/lib/kubelet/pods/<POD-ID>/volumes/kubernetes.io~secret/secret-data/password
```
