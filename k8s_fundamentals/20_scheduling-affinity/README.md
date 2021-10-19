# Node Affinities

In this training course, we will show how the Kubernetes Scheduler tries to keep things away from each other.

>Navigate to the folder `20_scheduling-affinity' from CLI, before you get started. 

## Inspect water-pod.yaml definition file and create the water-pod

```bash
cat water-pod.yaml
kubectl create -f water-pod.yaml
```

## Inspect fire-deployment.yaml definition file and create the fire-deployment

```bash
cat fire-deployment.yaml
kubectl create -f fire-deployment.yaml
```

## Verify that the pods location

>Pods `fire` must not be on the same node as the pod `water`.
```bash
kubectl get pods -o=custom-columns='POD_NAME:metadata.name,NODE_NAME:spec.nodeName'
```

## Cleanup

```bash
kubectl delete pod water
kubectl delete deployment fire
```

[Jump to Home](../README.md) | [Previous Training](../19_scheduling-node-selector/README.md) | [Next Training](../21_scheduling-taints-and-tolerations/README.md)