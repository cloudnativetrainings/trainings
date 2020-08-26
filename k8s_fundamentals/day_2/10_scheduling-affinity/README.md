# Node Affinities

In this course will show how the Kubernetes Scheduler tries to keep things away from each other.

## Inspect the [fire yaml file](./fire-pod.yaml) and create the pod

```bash
kubectl create -f fire-pod.yaml
```

## Inspect the [water yaml file](./water-deployment.yaml) and create the deployment

```bash
kubectl create -f water-deployment.yaml
```

## Verify that the pods location

Pods `water` must not be on the same node as the pod `fire`.

```bash
kubectl get pods -o=custom-columns='POD_NAME:metadata.name,NODE_NAME:spec.nodeName'
```

## Cleanup

```bash
kubectl delete pod fire
kubectl delete deployment water
```