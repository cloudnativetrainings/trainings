# ConfigMap

1. Create the following ConfigMap and Pod. Fix the errors.
```yaml 
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-configmap
data:
  hello: world
---
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: env-printer
    image: an-image
    command:
      - /bin/sh
      - -c
      - "echo $my_env_var && sleep 99d"
    env:
      - name: my-env-var
        valueFrom:
          configMapKeyRef:
            key: a-key
            name: a-configmap
```
2. Verify everything is fine via
```bash
kubectl get pods
kubectl logs my-pod
world
```
3. Cleanup
```bash
kubectl delete po,cm --all
```
