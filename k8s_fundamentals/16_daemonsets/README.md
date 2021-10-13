# DaemonSets

In the training, we will learn about Daemonsets.

>Navigate to the folder `16_dameonsets` from CLI, before you get started. 

## Inspect daemonset.yaml definition file and create the daemonset

```bash
cat daemonset.yaml
kubectl create -f daemonset.yaml
```

## Take a look at your Pods and Nodes

```bash
kubectl get po,no
```
>The number of pods for the daemonset has to match the number of nodes.

## Choose one Pod and take a look at its logging

```bash
kubectl logs <POD-NAME>
```

## Clean up

```bash
kubectl delete ds --all
```

[Jump to Home](../README.md) | [Previous Training](../15_hpas/README.md) | [Next Training](../17_jobs/README.md)