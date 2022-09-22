# Cordon

In this training, we will learn about how to cordon and uncordon a node.

>Navigate to the folder `23_cordon` from CLI, before you get started. 

## Create the deployment

```bash
kubectl create -f deployment.yaml
```
>Note that the scheduler tries to avoid having all two pods on one node.

## Cordon a node

* Check the node of each pod
  ```bash
  kubectl get pods -o wide
  ```

* Cordon one node
  ```bash
  kubectl cordon <NODE-NAME>
  ```

* Verify the state of the node
  ```bash
  kubectl get node
  ```

* Check the node of each pod
  ```bash
  kubectl get pods -o wide
  ```
>Cordon only avoids getting new workloads on the node. So no change happens.

## Scale the deployment to 5

```bash
kubectl scale deployment my-deployment --replicas 5
```
>The 4 new pods have to be created on the other node.

## Uncordon the node

```bash
kubectl uncordon <NODE-NAME>
```
>Note that no pods get re-scheduled due to doing uncordoning.

## Cleanup

```bash
kubectl delete deployment my-deployment
```

[Jump to Home](../README.md) | [Previous Training](../22_ingress/README.md) | [Next Training](../24_drain/README.md)