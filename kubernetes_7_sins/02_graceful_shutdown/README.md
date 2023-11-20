# Graceful Shutdown

In this training, we will create a pod and learn how to ensure a graceful shutdown of the application.

The application implements a shutdown hook and needs 10 seconds for a proper shutdown.

>Navigate to the folder `42_graceful-shutdown` from CLI, before you get started. 

## Possible data loss

### Create the Pod
Inspect pod.yaml definition file and create the pod
```bash
cat pod.yaml
kubectl create -f pod.yaml
```

### Follow the logs of the pod
Do this in a seperate terminal.
```bash
kubectl logs -f seven-sins-application
```

### Stop the Pod
```bash
kubectl delete pod seven-sins-application
```
>Note that the graceful shutdown has not finished successfully.

## Avoiding possible data loss

```yaml
...
spec:
  terminationGracePeriodSeconds: 12
...
```
### Re-Create the Pod
```bash
kubectl create -f pod.yaml
```

### Follow the logs of the pod
Do this in a seperate terminal.
```bash
kubectl logs -f seven-sins-application
```

### Stop the Pod again
```bash
kubectl delete pod seven-sins-application
```
>Note that the application now has enough time to do a graceful shutdown

## Danger Zone

### Re-Create the Pod
```bash
kubectl create -f pod.yaml
```

### Follow the logs of the pod
Do this in a seperate terminal.
```bash
kubectl logs -f seven-sins-application
```

### Stop the Pod again
```bash
kubectl delete pod seven-sins-application --grace-period=0
```
>Note that the application now has enough time to do a graceful shutdown

