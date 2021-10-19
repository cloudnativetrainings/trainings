# Multi Container Pod

In this training, we will work with a Pod which contains 2 containers.

>Navigate to the folder `04_multi-container-pods` from CLI, before you get started. 

## Inspect pod-v1.yaml definition file and create the pod

```bash
cat pod-v1.yaml
kubectl create -f pod-v1.yaml
```

## Get the logs of the Pod

```bash
kubectl logs -f my-pod
```
>This will not work, please follow the instructions or consult `--help`.

## Exec into the Pod

* Exec into the multi-container pod
  ```bash
  kubectl exec -it my-pod -- /bin/sh
  ```
  >Pay attention to the output.

* Find out how to exec into container-b of the Pod
  ```bash
  kubectl exec -it my-pod -c container-b -- /bin/sh
  ```

## Share a directory between 2 Containers in a Pod

* Inspect pod-v2.yaml definition file and re-create the pod
  ```bash
  cat pod-v2.yaml
  kubectl replace --force -f pod-v2.yaml
  ```

* Verify the output from container-b
  ```bash
  kubectl logs -f my-pod -c container-b
  ```

## Cleanup
* Delete the created resource - pod.
  ```bash
  kubectl delete pod my-pod
  ```

[Jump to Home](../README.md) | [Previous Training](../03_commands-and-args/README.md) | [Next Training](../05_replicasets/README.md)