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
