# Draining nodes

## Create the deployment, pod and daemonset

```bash
kubectl create -f .
```
## Try to drain the node where the pod `my-pod` is running

```bash
# Get the node
kubectl get pods -o wide

# Drain the node
kubectl drain <NODE-NAME>

# This will get aborted due to `my-daemonset` and `my-pod`
# Try again
kubectl drain <NODE-NAME> --ignore-daemonsets --force
```

## Take a look at the pods on that node

```bash
kubectl get pods -o wide
```

Note that the pod `my-pod` has gone forever. The pods for the deployment `my-deployment` got rescheduled to the other node and the pods for the daemonset `my-daemonset` are untouched.

## Uncordon the node

```bash
kubectl uncordon <NODE-NAME>
```

Note that the pod `my-pod` really has gone forever. The uncordon operation does not cause any re-scheduling happening.

## Cleanup

```bash
kubectl delete deployment my-deployment
kubectl delete daemonset my-daemonset
```