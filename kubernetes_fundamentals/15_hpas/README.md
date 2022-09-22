# Horizontal Pod Autoscaler

In the training, we will learn about Horizontal Pod Autoscaler.

>Navigate to the folder `15_hpas` from CLI, before you get started. 

## Create the service and the deployment

```bash
kubectl create -f service.yaml
kubectl create -f deployment.yaml
```

## Take a look at the resource consumption of your nodes and your pods

```bash
kubectl top nodes
kubectl top pods
```

## Inspect and create the hpa

```bash
kubectl create -f hpa.yaml
```

## Open a new Cloud Shell and watch the pods resource usage

```bash
watch -n 1 kubectl top pods
```

## Inspect the load-deployment and create the deployment

```bash
kubectl create -f load-deployment.yaml
```
>Take a look at the second terminal. Has the number of pods for my-deployment increased?

## Put more pressure on my-deployment

```bash
kubectl scale deployment load-deployment --replicas 5
```
>After a few seconds additional pods for my-deployment will appear.

## Cleanup

```bash
kubectl delete deployment --all
kubectl delete svc my-service
kubectl delete hpa my-autoscaler
```

[Jump to Home](../README.md) | [Previous Training](../14_statefulsets/README.md) | [Next Training](../16_daemonsets/README.md)