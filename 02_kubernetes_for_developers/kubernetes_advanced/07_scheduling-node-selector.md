# Node Selector

1. Show all nodes with its labels
```bash
kubectl get nodes --show-labels
```
2. Add a label to a node
```bash
kubectl label node <NODE-NAME> preferred=true
```
3. Create the following Pod
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
```bash
kubectl create -f pod.yaml
```
4. Verify that the pod is running on the labeled node
```bash
kubectl describe pod my-pod | grep Node:
```
