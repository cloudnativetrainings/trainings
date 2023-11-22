# Limits

In this training, you will learn about resource limits.

>Navigate to the folder `01_oom` from CLI, before you get started.

## Create the Pod
Inspect pod.yaml and service.yaml definition file and create the pod and the service
```bash
cat pod.yaml
kubectl create -f pod.yaml
```

## Leaking CPU
#TODO
```bash
# [TERMINAL-2] Attach to the application
kubectl attach -it seven-sins-application

# [TERMINAL-2] Set the application to not ready
leak cpu

watch -n 1 kubectl top pods    
```

>> Note that the Container does not get restarted. The amount of CPU is limited to 30 MilliCores.


## Leaking Memory
#TODO
```bash
# Restart the Pod
kubectl delete pod seven-sins-application --force --grace-period=0
kubectl apply -f pod.yaml

# [TERMINAL-2] Attach to the application
kubectl attach -it seven-sins-application

# [TERMINAL-2] Set the application to not ready
leak mem

# After the Container gets restarted (~ 10 seconds) you see this in the RESTARTS column of
kubectl get pods

# The reason for the last restart (=OOMKilled) you can find out via the following command 
kubectl get pod seven-sins-application -o yaml 
```

## Cleanup
Delete the created resources.
```bash
kubectl delete all --all --force --grace-period=0
```

