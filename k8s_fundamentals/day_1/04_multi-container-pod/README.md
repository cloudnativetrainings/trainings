# Multi Container Pod

In this training we will work with a Pod containing 2 containers.

## Inspect the [pod yaml file](./pod-v1.yaml) and create the pod

```bash
kubectl create -f pod-v1.yaml
```

## Get the logs of the Pod

This will not work, please follow the instructions and consult `--help`.

```bash
kubectl logs -f multi-container-pod
```

## Exec into the Pod

Pay attention to the output.

```bash
kubectl exec -it multi-container-pod -- /bin/sh
```

## Find out how to exec into container-b of the Pod

## Share a directory between 2 Containers in a Pod

### Inspect the [pod yaml file](./pod-v2.yaml) and create the pod

```bash
kubectl replace --force -f pod-v2.yaml
```

### Verify the output from container-b

```bash
kubectl logs -f my-pod -c container-b
```

## Cleanup

```bash
kubectl delete pod my-pod
```
