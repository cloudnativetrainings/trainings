# CronJob

In this course we will create a job which will run every minute.

## Inspect and create the cronjob

```bash
kubectl create -f cronjob.yaml
```

## Take a look at running cronjobs and the pods

It can take a while that the job is completed.

```bash
kubectl get cronjobs,pods
```

## Cleanup

```bash
kubectl delete cronjobs --all
```

[Jump to Home](../README.md) | [Previous Training](../17_jobs/README.md) | [Next Training](../19_scheduling-node-selector/README.md)