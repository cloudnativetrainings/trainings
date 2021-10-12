# Revision History

## Inspect and create the deployment

```bash
kubectl create -f deployment.yaml
```

## Change the image of the deployment

```bash
kubectl set image deployment my-deployment nginx=nginx:1.19.1 --record
```

## Take a look at the rollout history

```bash
kubectl rollout history deployment my-deployment
```

## Rollback to the previous version

```bash
kubectl rollout undo deployment my-deployment
```

## Take a look into the Deployment

```bash
kubectl get deployment my-deployment -o yaml | grep "revision:\|generation:\|resourceVersion:"
```

## Scale up the Deployment

```bash
kubectl scale deployment my-deployment --replicas 3
```

## Take a look into the Deployment

Can you explain why there is a diff between the revision and the generation?

```bash
kubectl get deployment my-deployment -o yaml | grep "revision:\|generation:\|resourceVersion:"
```

## Restart all the Pods of the Deployment

```bash
kubectl rollout restart deployment my-deployment
```

## Cleanup

```bash
kubectl delete deployment --all
```

[Jump to Home](../README.md) | [Previous Training](../06_deployments/README.md) | [Next Training](../08_services/README.md)