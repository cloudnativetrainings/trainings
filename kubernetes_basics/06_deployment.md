# Deployment

1. Create a the following `deployment.yaml` file
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: my-deployment
  template:
    metadata:
      labels:
        app: my-deployment
    spec:
      containers:
      - name: my-deployment-container
        image: nginx
```
2. Create the Deployment
```bash
kubectl create -f deployment.yaml
```
3. Add another terminal and watch the Pods 
```bash
watch -n 1 kubectl get pods
```
4. Scale the number of replicas to 3 and take a look ath the second terminal
```bash
kubectl scale deployment my-deployment --replicas 3
```
5. Change the image of the deployment and take a look at the second terminal
```bash
kubectl set image deployment my-deployment my-deployment-container=nginx:alpine
```
6. Change the rollout strategy in the deployment to the following. Set the replicas to 3 within the yaml file.
```yaml
...
strategy:
  rollingUpdate:
    maxSurge: 25%
    maxUnavailable: 25%
  type: RollingUpdate
...
```
5. Change the image of the deployment and take a look at the second terminal
```bash
kubectl set image deployment my-deployment my-deployment-container=nginx:1.16.1
```
6. Cleanup
```bash
kubectl delete deployment --all
```