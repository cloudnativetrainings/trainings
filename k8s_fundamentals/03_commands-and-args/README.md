# Commands and Args

In this training, we will learn to create a customized Pod.

>Navigate to the folder `03_commands-and-args` from CLI, before you get started. 

## Inspect and create the pod

```bash
cat pod.yaml
kubectl create -f pod.yaml
```

## Take a look at the Pods

```bash
kubectl get pods
```
>Why is the Pod not in `RUNNING` state?

## Get more info about the Pod

>Pay attention to the structure  `Last State:`.

```bash
kubectl describe pod my-pod | grep -A4 "Last State:"
```

## Add the following command and arguments to the container

```yaml
...
- name: busybox
  image: busybox:1.32.0
  command: [ "sleep" ]
  args: [ "600" ]
```

## Re-create the Pod

```bash
kubectl replace --force -f pod.yaml
```
>Verify the pod state if running or not using `kubectl get pods` command. You will observe that issue is resolved and pod is in running state. 

## Cleanup
* Delete the created resource - pod.
  ```bash
  kubectl delete pod my-pod
  ```

[Jump to Home](../README.md) | [Previous Training](../02_pods/README.md) | [Next Training](../04_multi-container-pods/README.md)