# CronJob

In this training course, we will create a job which will run every minute.

>Navigate to the folder `18_cronjobs` from CLI, before you get started. 

## Inspect cronjob.yaml definition file and create the cronjob

```bash
cat cronjob.yaml
kubectl create -f cronjob.yaml
```

## Take a look at running cronjobs and the pods

>It can take a while that the job is completed.
```bash
kubectl get cronjobs,pods
```

## Cleanup

```bash
kubectl delete cronjobs --all
```

[Jump to Home](../README.md) | [Previous Training](../17_jobs/README.md) | [Next Training](../19_scheduling-node-selector/README.md)