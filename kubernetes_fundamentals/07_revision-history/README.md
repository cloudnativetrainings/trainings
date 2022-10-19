# Revision History

In the training, we will learn how to track the Revision History.

>Navigate to the folder `07_revision-history` from CLI, before you get started. 

## Inspect deployment.yaml definition file and create the deployment

```bash
kubectl create -f deployment.yaml
```

## Change the image of the deployment

```bash
kubectl set image deployment my-deployment nginx=nginx:1.19.1 --record
```

> You will receive a message that `--record` is deprecated. This is how it works now:

```bash
kubectl set image deployment my-deployment nginx=nginx:1.19.1

# change-cause is however you want to document this change
kubectl annotate deployment/my-deployment kubernetes.io/change-cause="Nginx version is updated to 1.19.1"
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