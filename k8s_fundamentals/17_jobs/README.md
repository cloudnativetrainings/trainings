# Job

In this training, we will create a job and parallelize its execution.

>Navigate to the folder `17_jobs` from CLI, before you get started. 

## Inspect  job.yaml definition file and create the job

```bash
cat job.yaml
kubectl create -f job.yaml
```

## Take a look at running Jobs and the Pods

>It can take a while that the job is completed.
```bash
kubectl get pods,jobs
```

## Increase the amount of executions to 10 and parallelize them

```yaml
...
spec:
  completions: 10
  parallelism: 5
  template:
...
```

Re-create the job.

```bash
kubectl replace -f job.yaml  --force
```

## Watch the running jobs and the pods

```bash
watch -n 1 kubectl get pods,jobs
```

## Clean up

```bash
kubectl delete jobs --all
```

[Jump to Home](../README.md) | [Previous Training](../16_daemonsets/README.md) | [Next Training](../18_cronjobs/README.md)