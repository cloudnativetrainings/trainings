# ReplicaSet

In this training, we will learn about Replicasets.

>Navigate to the folder `05_replicasets` from CLI, before you get started. 

## Inspect the replicaset.yaml definition file and create the replicaset

```bash
cat replicaset.yaml
kubectl create -f replicaset.yaml
```
>Find and fix the two issues in there.

## Take a look at the number of Pods

```bash
kubectl get pods
```

## Scale the number of replicas to 3

```bash
kubectl scale replicaset my-replicaset --replicas 3
```

Open second terminal to watch the Pods
```bash
watch -n 1 kubectl get pods
```

## Delete one of the Pods

```bash
kubectl delete pod <POD-NAME>
```

Open second terminal to watch the Pods
```bash
watch -n 1 kubectl get pods
```

## Cleanup
Delete the ReplicaSet
```bash
kubectl delete replicaset my-replicaset
```
Verify if replicaset is delete including all the associated pods 
```bash
kubectl get rs,po
```

[Jump to Home](../README.md) | [Previous Training](../04_multi-container-pods/README.md) | [Next Training](../06_deployments/README.md)