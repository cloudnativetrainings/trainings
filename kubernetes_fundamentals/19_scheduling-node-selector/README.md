# Node Selector

In this training course, we will learn about Node Selector.

>Navigate to the folder `19_scheduling-node-selector` from CLI, before you get started. 

## Show all Nodes with its Labels

```bash
kubectl get nodes --show-labels
```

## Add a Label to a node

```bash
kubectl label node <NODE-NAME> preferred=true
```

## Inspect pod.yaml definition file and create the pod

```bash
cat pod.yaml
kubectl create -f pod.yaml
```

## Verify that the pod is running on the labeled node

```bash
 kubectl get pods -o wide
```

## Cleanup

```bash
kubectl label node <NODE-NAME> preferred-
kubectl delete pods my-pod
```

[Jump to Home](../README.md) | [Previous Training](../18_cronjobs/README.md) | [Next Training](../20_scheduling-affinity/README.md)