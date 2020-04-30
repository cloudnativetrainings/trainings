# Revision History

1. Create a Deployment
```bash
kubectl run my-nginx --image nginx --port 80
```
2. Change the image of the deployment 
```bash
kubectl set image deployment my-nginx my-nginx=nginx:alpine --record
```
3. Take a look at the rollout history
```bash
kubectl rollout history deployment my-nginx
```
4. Rollback to the previous version
```bash
kubectl rollout undo deployment my-nginx
```
5. Take a look into the Deployment
```bash
kubectl get deployment my-nginx -o yaml | grep "revision:\|generation:\|resourceVersion:"
```
6. Scale up the Deployment
```bash
kubectl scale deployment my-nginx --replicas 3
```
7. Take a look into the Deployment. Can you explain why there is a diff between the revision and the generation?
```bash
kubectl get deployment my-nginx -o yaml | grep "revision:\|generation:\|resourceVersion:"
```
8. Cleanup
```bash
kubectl delete deployment --all
```