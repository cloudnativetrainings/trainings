# There may be Dragons

Although you taught Kubernetes about the proper period of time to do a graceful shutdown data loss can still happen.

In this lab you will learn about a possible reason for data loss.

>Navigate to the folder `02_2_dragons` from CLI, before you get started.

## Create the Pods
Inspect pod-A.yaml and pod-B.yaml definition files and create the pods.
```bash
cat pod-A.yaml
cat pod-B.yaml
kubectl create -f pod-A.yaml
kubectl create -f pod-B.yaml
kubectl get pods
```
>> Note that the Applications and the yaml Manifests are exactly the same.

## Watch the log files of the Pods
>>Note that `kubectl logs -f ...` command will not work here, due to the logging info will get lost after termination of the Pods.
>> Note you will additional terminals for doing this.
```bash
# Get the Worker Nodes for the Pods
kubectl get pods -o wide

# SSH into the Worker Nodes where the Pods are running
gcloud compute ssh <NODE>

# [WORKER-NODE] Switch to the default logging directory of the Worker Node
cd /var/log/containers 

# [WORKER-NODE] Verify the log files are present
ls seven-sins-application-*

# [WORKER-NODE] Tail each log file
sudo tail -f seven-sins-application-a<TAB>
sudo tail -f seven-sins-application-b<TAB>

# Delete the pods
kubectl delete -f .  
```

## Verification of Graceful Shutdown
Take a look at the logfiles. Did the graceful shutdown happen on both Pods? If not, why?
