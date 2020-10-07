# Draining Nodes

## Create the deployment

```bash
kubectl create -f deployment.yaml
```

Note that the scheduler tries to avoid having all two pods on one node.

## Cordon a node

```bash
# Check the node of each pod
kubectl get pods -o wide

# Cordon one node
kubectl cordon <NODE-NAME>

# Verify the state of the node
kubectl get node

# Check the node of each pod
kubectl get pods -o wide
```

Cordon only avoids getting new workloads on the node. So no change happens.

## Scale the deployment to 5

```bash
kubectl scale deployment my-deployment --replicas 5
```

The 4 new pods have to be created on the other node.

## Uncordon the node

```bash
kubectl uncordon <NODE-NAME>
```

Note that no pods get re-scheduled due to doing uncordoning.

## Cleanup

```bash
kubectl delete deployment my-deployment
```
