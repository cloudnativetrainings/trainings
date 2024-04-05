# Resource Limits

In this training, you will learn about resource limits.

The application implements a CPU and a Memory leak.

> Navigate to the folder `01_oom` from CLI, before you get started.

## Create the Pod

Inspect pod.yaml and service.yaml definition file and create the pod and the service

```bash
cat pod.yaml
kubectl create -f pod.yaml
```

## Leaking CPU

Learn what happens when your application reaches its CPU limits.

```bash
# [TERMINAL-2] Attach to the application
kubectl attach -it seven-sins-application

# [TERMINAL-2] Engage the CPU leak
leak cpu

# Check what is happening with the Pod.
watch -n 1 kubectl top pods
```

> > Note that the Container does not get restarted. The amount of CPU is limited to 30 MilliCores.

## Leaking Memory

Learn what happens when your application reaches its Memory limits.

```bash
# Restart the Pod
kubectl delete pod seven-sins-application --force --grace-period=0
kubectl apply -f pod.yaml

# [TERMINAL-2] Attach to the application
kubectl attach -it seven-sins-application

# [TERMINAL-2] Engage the Memory Leak
leak mem

# After the Container gets restarted (~ 10 seconds) you see this in the RESTARTS column of
kubectl get pods

# The reason for the last restart (=OOMKilled) you can find out via the following command
kubectl get pod seven-sins-application -o jsonpath='{.status.containerStatuses[0].lastState}' | jq
```

## Cleanup

Delete the created resources.

```bash
kubectl delete all --all --force --grace-period=0
```
