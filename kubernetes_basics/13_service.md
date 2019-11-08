# Services

1. Create a Deployment via the following command
```bash
kubectl run -it nginx --image nginx --port 80
```
2. Create the yaml configuration for the Service via the following command
```bash
kubectl expose deployment nginx --type NodePort --dry-run -o yaml > svc.yaml
```
3. Inspect the file service.yaml and apply it.
```bash
kubectl apply -f service.yaml
```
4. Take a look at the created Endpoints and IPs of the Pods
```bash
kubectl get po,ep -o wide
```
5. Scale up the deployment via
```bash
kubectl scale deployment nginx --replicas 3
```
6. Take a look at the created Endpoints and IPs of the Pods
```bash
kubectl get po,ep -o wide
```
7. Clean up
```bash
kubectl delete svc,deploy nginx
```