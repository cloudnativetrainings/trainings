# Using a Volume in a Pod

In the training, we will learn how to use persistentvolumeclaim in a pod.

>Navigate to the folder `13_persistence-use-volume` from CLI, before you get started. 

## Inspect and create the pvc

```bash
kubectl create -f pvc.yaml
```

## Inspect and create the pod

```bash
kubectl create -f pod.yaml
```
>There is an issue with this structure. Try to fix the error and verify via `kubectl get po`. You are finished if your pod is in state `Running`


## Verify the timestamps in the file `/app/buffer`

```bash
kubectl exec -it my-pod -- cat /app/buffer
```

## Delete the pod

```bash
kubectl delete pod my-pod
```

## Re-create the pod

```bash
kubectl create -f pod.yaml
```

## Verify the timestamps of the previous pod run are still in the file `/app/buffer` 

```bash
kubectl exec -it my-pod -- cat /app/buffer
```

## Cleanup

```bash
kubectl delete pod my-pod
kubectl delete pv,pvc --all
```

[Jump to Home](../README.md) | [Previous Training](../12_persistence-dynamic/README.md) | [Next Training](../14_statefulsets/README.md)