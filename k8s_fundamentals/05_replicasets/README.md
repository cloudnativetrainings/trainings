# ReplicaSet

## Create the replicaset

```bash
kubectl create -f replicaset.yaml
```

Find and fix the two issues in there.

## Take a look at the number of Pods

```bash
kubectl get pods
```

## Scale the number of replicas to 3

```bash
kubectl scale replicaset my-replicaset --replicas 3
```

## Delete one of the Pods

```bash
kubectl delete pod <POD-NAME>
```

## Take a look at the number of Pods

```bash
kubectl get pods
```

## Cleanup

```bash
## delete the ReplicaSet
kubectl delete replicaset my-replicaset

## also the Pods will get deleted
kubectl get rs,po
```
