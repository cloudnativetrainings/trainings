# Node Affinities

In this course we will use taints and tolerations to influence scheduling

## Taint the node

```bash
kubectl taint nodes <NODE-NAME> foo=bar:NoSchedule
```

## Verify the taint on the node
```bash
kubectl get nodes -o=custom-columns='NODE_NAME:metadata.name,TAINTS:spec.taints[*]'
```

## Inspect and create the deployment

```bash
kubectl create -f deployment.yaml
```

## Verify all pods not running on the tainted node

```bash
kubectl get pods -o=custom-columns='POD_NAME:metadata.name,NODE_NAME:spec.nodeName'
```

## Inspect and create the pod

```bash
kubectl create -f pod.yaml
```

## Verify that the pod is running on the tainted node

```bash
kubectl get pods -o=custom-columns='POD_NAME:metadata.name,NODE_NAME:spec.nodeName'
```

## Cleanup

```bash
kubectl delete pod my-pod
kubectl delete deployment my-deployment
kubectl taint nodes <NODE-NAME> foo=bar:NoSchedule-
```