# Using a Volume in a Pod

## 1. Create the following Pod

## Inspect the [pvc yaml file](./pvc.yaml) and create the pvc

```bash
kubectl create -f pvc.yaml
```

## Inspect the [pod yaml file](./pod.yaml) and create the pod

```bash
kubectl create -f pod.yaml
```

There is an issue with this structure. Try to fix the error and verify via `kubectl get po`. You are finished if your pod is in state `Running`


## Verify the timestamps in the file `/app/buffer`

```bash
kubectl exec -it my-pod -- cat /app/buffer
```

## Delete the pod

```bash
kubectl delete pod my-pod
```

## Re-create the [pod yaml file](./pod.yaml) 

```bash
kubectl create -f pod.yaml
```

## Verify the timestamps of the previous pod run are still in the file `/app/buffer` 

```bash
kubectl exec -it my-pod -- cat /app/buffer
```

## Cleanup

```bash
kubectl delete po,svc my-pod
kubectl delete pv,pvc --all
```
