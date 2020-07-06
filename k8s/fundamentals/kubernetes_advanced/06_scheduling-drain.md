# Draining Nodes

## 1. Display all nodes and choose one to cordon

```bash
kubectl get nodes
kubectl cordon <NODE-NAME>
```

## 2. Take a look at the Pods at the Node

Note that there is still some workloads on that worker node.

```bash
kubectl describe node <NODE-NAME>
```

## 3. Move the workload from the Worker Node

You will get an error message. Follow the instructions.

```bash
kubectl drain <NODE-NAME>
```

## 4. Take a look at the Pods on that Node

Note that there is still some workloads on that worker node.

```bash
kubectl describe node <NODE-NAME>
```

## 5. Uncordon the Node

```bash
kubectl uncordon <NODE-NAME>
```
