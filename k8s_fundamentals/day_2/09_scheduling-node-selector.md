# Node Selector

## 1. Show all Nodes with its Labels

```bash
kubectl get nodes --show-labels
```

## 2. Add a Label to a Node

```bash
kubectl label node <NODE-NAME> preferred=true
```

## 3. Create the following Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-pod
      image: nginx
  nodeSelector:
    preferred: "true"
```

Apply it to your cluster.

```bash
kubectl create -f pod.yaml
```

## 4. Verify that the Pod is running on the labeled Node

```bash
kubectl describe pod my-pod | grep Node:
```
