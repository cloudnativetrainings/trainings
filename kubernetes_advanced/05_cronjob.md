# CronJob
In this course we will create a job which will run every minute.

1. Create a CronJob like this
```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: my-cronjob
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: my-cronjob
              image: busybox
              command: [ "/bin/sh" ]
              args: [ "-c", "date" ]
          restartPolicy: OnFailure
```
```bash
kubectl apply -f cronjob.yaml
```
2. Take a look at running cronjobs and the pods. It can take a while that the job is completed
```bash
kubectl get cronjobs,pods
```
5. Clean up.
```bash
kubectl delete cronjobs --all
```