# Lost Pods

In this training, you will learn about Pods which will not get restarted.

> Navigate to the folder `04_no_restart` from CLI, before you get started.

## Setup Environment

```bash
# configure kubectl for being allowed to talk to the kubernetes cluster
export KUBECONFIG=<PATH_TO_01_magicless-kubernetes-LAB>/secrets/admin.kubeconfig

# eg 
# export KUBECONFIG=/home/hubert_training/trainings/kubernetes_fundamentals_for_operators/01_magicless-kubernetes/secrets/admin.kubeconfig
```

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
