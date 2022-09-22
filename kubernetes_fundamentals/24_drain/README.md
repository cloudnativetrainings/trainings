# Draining nodes

In this training, we will learn about how to drain and uncordon a node.

>Navigate to the folder `24_drain` from CLI, before you get started. 

## Create the deployment, pod and daemonset

```bash
kubectl create -f .
```

## Drain the node 

* Get the node
  ```bash
  kubectl get pods -o wide
  ```

* Drain the node, where the pod `my-pod` is running
  ```bash
  kubectl drain <NODE-NAME>
  ```
  >This will get aborted due to `my-daemonset` and `my-pod`

* Try again
  ```bash
  kubectl drain <NODE-NAME> --ignore-daemonsets --force
  ```
  
* Take a look at the pods on that node
  ```bash
  kubectl get pods -o wide
  ```
  >Note that the pod `my-pod` has gone forever. The pods for the deployment `my-deployment` got rescheduled to the other node and the pods for the daemonset `my-daemonset` are untouched.

## Uncordon the node

```bash
kubectl uncordon <NODE-NAME>
```
>Note that the pod `my-pod` really has gone forever. The uncordon operation does not cause any re-scheduling happening.

## Cleanup

```bash
kubectl delete deployment my-deployment
kubectl delete daemonset my-daemonset
```

[Jump to Home](../README.md) | [Previous Training](../23_cordon/README.md) | [Next Training](../25_authentication/README.md)