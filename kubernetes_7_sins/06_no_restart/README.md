# Lost Pods

In this training, you will learn about Pods which will not get restarted.

> Navigate to the folder `06_no_restart` from CLI, before you get started.

## Setup the workloads

### Inspect and create the Pod

Inspect pod.yaml definition file and create the pod

```bash
cat pod.yaml
kubectl create -f pod.yaml
```

### Inspect and create the Deployment

Inspect pod.yaml definition file and create the pod

```bash
cat deployment.yaml
kubectl create -f deployment.yaml
```

### Check the running Pods

```bash
kubectl get pods
```

## Maintenance Window ;)

### Drain all the Worker Nodes

```bash
kubectl drain $(kubectl get nodes -o=jsonpath='{.items[*].metadata.name}') --force --ignore-daemonsets --delete-emptydir-data
kubectl get nodes
```

### Cordon all the Worker Nodes

```bash
kubectl uncordon $(kubectl get nodes -o=jsonpath='{.items[*].metadata.name}')
kubectl get nodes
```

### Check the running Pods

```bash
kubectl get pods
```

> Note that the manually created Pod was not restarted.

## Teardown

```bash
kubectl delete all --all --force --grace-period=0
```
