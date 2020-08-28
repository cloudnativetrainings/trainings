# Node Selector

## Show all Nodes with its Labels

```bash
kubectl get nodes --show-labels
```

## Add a Label to a node

```bash
kubectl label node <NODE-NAME> preferred=true
```

## Inspect and create the pod

```bash
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
