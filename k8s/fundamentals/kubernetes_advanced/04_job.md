# Job

In this course we will create a job and parallelize its execution.

## 1. Create a Job like this

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: my-job
spec:
  template:
    spec:
      containers:
      - name: my-job
        image: busybox
        command: [ "sleep" ]
        args: [ "10" ]
      restartPolicy: Never
```

Apply it to your cluster.

```bash
kubectl create -f job.yaml
```

## 2. Take a look at running jobs and the pods

It can take a while that the job is completed.

```bash
kubectl get pods,jobs
```

## 3. Increase the amount of executions to 10 and parallelize them

```yaml
...
spec:
  completions: 10
  parallelism: 5
  template:
    ...
```

Apply it to your cluster.

```bash
kubectl apply -f job.yaml
```

## 4. Watch the running jobs and the pods

```bash
watch -n 1 kubectl get pods,jobs
```

## 5. Clean up

```bash
kubectl delete jobs --all
```
