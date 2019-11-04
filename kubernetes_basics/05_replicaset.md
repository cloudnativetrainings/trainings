# ReplicaSet

1. Create a the following ReplicaSet serving an `nginx` container. Find and fix the two issues in there.
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-replicaset
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: another-app
    spec:
      containers:
      - name: my-container
        image: my-image        
```
2. Take a look at the number of Pods
```bash
kubectl get pods
```
3. Scale the number of replicas to 3
```bash
kubectl scale replicaset my-replicaset --replicas 3
```
4. Delete one of the Pods
```bash
kubectl delete pod <POD-NAME>
```
5. Take a look at the number of Pods
```bash
kubectl get pods
```
6. Expose the ReplicaSet
```bash
kubectl expose replicaset my-replicaset --type NodePort
```
7. Take a look at the Endpoints and Pod IPs
```bash
kubectl get svc,endpoints,pods -o wide
```
8. Cleanup
```bash
# Delete the ReplicaSet
kubectl delete replicaset,service my-replicaset
# Also the Pods and Endpoints will get deleted
kubectl get rs,po,svc,ep
```
