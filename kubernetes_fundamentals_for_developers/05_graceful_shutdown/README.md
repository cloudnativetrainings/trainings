# Graceful Shutdown

In this training, we will create a pod and learn how to ensure a graceful shutdown of the application.

The application implements a shutdown hook and needs 10 seconds for a proper shutdown.

Change into the lab directory:

```bash
cd $HOME/trainings/kubernetes_application_development/05_graceful_shutdown
```

## Possible data loss

### Create the Pod

Inspect pod.yaml definition file and create the pod

```bash
cat k8s/pod.yaml
kubectl create -f k8s/pod.yaml
```

### Follow the logs of the pod

> [!IMPORTANT]
> Do this in a seperate terminal.

```bash
kubectl logs -f app
```

### Stop the Pod

```bash
kubectl delete pod app
```

> [!TIP]
> Note that the graceful shutdown has not finished successfully.

## Avoiding possible data loss

Update `k8s/pod.yaml` file:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  terminationGracePeriodSeconds: 12  # --> Change this line
  containers:
    - name: app
      image: quay.io/kubermatic-labs/training-application:1.0.0-go
      imagePullPolicy: Always
```

### Re-Create the Pod

```bash
kubectl create -f k8s/pod.yaml
```

### Follow the logs of the pod

> [!IMPORTANT]
> Do this in a seperate terminal.

```bash
kubectl logs -f app
```

### Stop the Pod again

```bash
kubectl delete pod app
```

> [!TIP]
> Note that, this time the application now has enough time to do a graceful shutdown

## Danger Zone

### Re-Create the Pod

```bash
kubectl create -f k8s/pod.yaml
```

### Follow the logs of the pod

> [!IMPORTANT]
> Do this in a seperate terminal.

```bash
kubectl logs -f app
```

### Stop the Pod again

This time, provide the `Grace Period` on the command line:

```bash
kubectl delete pod app --grace-period=0
```

> Note that the application now does not have enough time to do a graceful shutdown
