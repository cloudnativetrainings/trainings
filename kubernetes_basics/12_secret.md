# ConfigMap

1. Create the following ConfigMap and Pod. Fix the errors.
```yaml 
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
stringData:
  secret: value
---
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: vol-printer
    image: an-image
    command:
      - /bin/sh
      - -c
      - "sleep 99d"
    volumeMounts:
      - name: volume-name
        mountPath: /opt/my-volume
  volumes:
    - name: my-volume-name
      secret:
        secretName: the-secret
```
2. Verify everything fine via
```bash
kubectl exec -it my-pod -- cat /opt/my-volume/secret
```
3. Cleanup
```bash
kubectl delete pod my-pod
kubectl delete secret my-secret
```
