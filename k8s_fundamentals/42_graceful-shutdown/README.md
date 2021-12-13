# Graceful Shutdown

In this training, we will create a pod and learn how to ensure a graceful shutdown of the application.

The application implements a shutdown hook and needs 10 seconds for a proper shutdown.

>Navigate to the folder `42_graceful-shutdown` from CLI, before you get started. 

## Create the Pod
Inspect pod.yaml definition file and create the pod
```bash
cat pod.yaml
kubectl create -f pod.yaml
```

## Follow the logs of the pod
Do this in a seperate terminal.
```bash
kubectl logs -f my-app
```

## Stop the Pod
```bash
kubectl delete pod my-app
```
>Note that the graceful shutdown has not finished successfully.

## Adapt the graceful shutdown period

```yaml
...
spec:
  terminationGracePeriodSeconds: 12
...
```
## Re-Create the Pod
```bash
kubectl create -f pod.yaml
```

## Follow the logs of the pod
Do this in a seperate terminal.
```bash
kubectl logs -f my-app
```

## Stop the Pod again
```bash
kubectl delete pod my-app
```
>Note that the application now has enough time to do a graceful shutdown
