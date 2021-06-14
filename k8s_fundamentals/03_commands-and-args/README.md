# Commands and Args

In this training we will create a customized Pod.

## Inspect and create the pod

```bash
kubectl create -f pod.yaml
```

## Take a look at the Pods

```bash
kubectl get pods
```

Why is the Pod not in `RUNNING` state?

## Get more info about the Pod

Pay attention to the structure  `Last State:`.

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

## Cleanup

```bash
kubectl delete pod my-pod
```
