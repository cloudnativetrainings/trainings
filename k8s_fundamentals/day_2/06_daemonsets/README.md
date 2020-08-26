# DaemonSets

## Inspect the [daemonset yaml file](./daemonset.yaml) and create the daemonset

```bash
kubectl create -f daemonset.yaml
```

## Take a look at your Pods and Nodes

```bash
kubectl get po,no
```
The number of pods for the daemonset has to match the number of nodes.

## Choose one Pod and take a look at its logging

```bash
kubectl logs <POD-NAME>
```

## Clean up

```bash
kubectl delete ds --all
```
