# Pods

In this training, we will create a pod and learn how to interact with it.

>Navigate to the folder `02_pods` from CLI, before you get started. 

## Create Pod
* Inspect pod.yaml definition file and create the pod
  ```bash
  cat pod.yaml
  kubectl create -f pod.yaml
  ```

## Getting help

* Getting info and examples for the 'get' command
  ```bash
  kubectl get --help
  ```

* Get info about a specific yaml structure
  ```bash
  kubectl explain pod.metadata.name
  ```

* Get short info about a specific yaml structure
  ```bash
  kubectl explain --recursive pod.spec.containers.ports
  ```

## Get infos of a pod

* Show all Pods
  ```bash
  kubectl get pods
  ```

* Show all Pods with labels
  ```bash
  kubectl get pods --show-labels
  ```

* Show all Pods with IP address and node information
  ```bash
  kubectl get pods -o wide
  ```

* Store a Pod's yaml definition into a file
  ```bash
  kubectl get pod my-pod -o yaml > pod-output.yaml
  ```
  >You can check the definition using `cat pod-output.yaml`

## Describe a pod
* Show details of the pod including events
  ```bash
  kubectl describe pod my-pod
  ```

## Debug a Pod

* Get logs of a Container
  ```bash
  kubectl logs my-pod
  ```

* Follow the logs of a Container
  ```bash
  kubectl logs -f my-pod
  ```

* Exec into a Container
  ```bash
  kubectl exec -it my-pod -- bash
  ```

## Cleanup
* Delete the created resource - pod.
  ```bash
  kubectl delete pod my-pod
  ```

[Jump to Home](../README.md) | [Previous Training](../01_hello-k8s/README.md) | [Next Training](../03_commands-and-args/README.md)