# Pods

In this training we will create a pod and learn how to interact with it.

## Inspect the and create the pod

```bash
kubectl create -f pod.yaml
```

## Getting help

```bash
# Getting info and examples for the 'get' command
kubectl get --help
# Get info about a specific yaml structure
kubectl explain pod.metadata.name
# Get short info about a specific yaml structure
kubectl explain --recursive pod.spec.containers.ports
```

## Gett infos of a pod

```bash
## show all Pods
kubectl get pods

## show all Pods with labels
kubectl get pods --show-labels

## show all Pods with IP address
kubectl get pods -o wide

## store a Pod's yaml definition into a file
kubectl get pod my-pod -o yaml > pod.yaml
```

## Describe a pod

```bash
kubectl describe pod my-pod
```

## Debug a Pod

```bash
## get logs of a Container
kubectl logs my-pod

## follow the logs of a Container
kubectl logs -f my-pod

## exec into a Container
kubectl exec -it my-pod -- bash
```

## Cleanup

```bash
kubectl delete pod my-pod
```
