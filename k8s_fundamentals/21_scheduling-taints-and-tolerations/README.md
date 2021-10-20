# Taints and Tolerations

In this training course, we will use taints and tolerations to influence scheduling.

>Navigate to the folder `21_scheduling-taints-and-tolerations` from CLI, before you get started. 

## Taint the node

```bash
kubectl taint nodes <NODE-NAME> foo=bar:NoSchedule
```

## Verify the taint on the node

```bash
kubectl get nodes -o=custom-columns='NODE_NAME:metadata.name,TAINTS:spec.taints[*]'
```

## Inspect deployment.yaml definition file and create the deployment

```bash
cat deployment.yaml
kubectl create -f deployment.yaml
```

## Verify all pods not running on the tainted node

```bash
kubectl get pods -o=custom-columns='POD_NAME:metadata.name,NODE_NAME:spec.nodeName'
```

## Inspect pod.yaml definition file and create the pod

```bash
cat pod.yaml
kubectl create -f pod.yaml
```

## Verify that the pod is running on the tainted node

```bash
kubectl get pods -o=custom-columns='POD_NAME:metadata.name,NODE_NAME:spec.nodeName'
```

## Cleanup

```bash
kubectl delete pod my-pod
kubectl delete deployment my-deployment
kubectl taint nodes <NODE-NAME> foo=bar:NoSchedule-
```

[Jump to Home](../README.md) | [Previous Training](../20_scheduling-affinity/README.md) | [Next Training](../22_ingress/README.md)