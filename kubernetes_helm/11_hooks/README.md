# Writing Hooks

In this task, you will learn how to write Hooks.

> Navigate to the directory `$HOME/trainings/kubernetes_helm/11_hooks`, before getting started.

## Inspect the Chart

Take a look at the Hooks.

```bash
cat ./my-app/templates/hook-pre-install.yaml

cat ./my-app/templates/hook-pre-delete.yaml
```

## Running Hooks

To see what is happening, it is recommended to open an additional Shell and watch resources:

```bash
watch -n 1 kubectl get job,pod
```

```bash
helm install hooks ./my-app
```

Verify the first Hook was run.

```bash
helm uninstall hooks
```

Verify the second Hook was run.

Delete the jobs

```bash
kubectl delete job --all
```

## Running weighted Hooks

Add an additional pre-install Hook by copying the hook-pre-install-yaml file.

Add weights to the pre-install Hooks via the annotation `"helm.sh/hook-weight": "1"`.

```bash
helm install hooks ./my-app
```

Verify the order of the two pre-install hooks.

```bash
helm uninstall hooks
```

Delete the jobs

```bash
kubectl delete job --all
```

## Automatically delete Hook jobs

Add the hook-delete-policy to the Hooks via the `"helm.sh/hook-delete-policy": "hook-succeeded"` annotation.

```bash
helm install hooks ./my-app
```

> Note that the Jobs for the Hooks will get deleted, after they are completed successfully.

- Delete the release

  ```bash
  helm uninstall hooks
  ```

## Disabling Hooks

Hooks can block the install/uninstall process, if they eg are in state `CrashLoopBackOff`. You can disable via the following.

```bash
helm install hooks ./my-app --no-hooks
```

## Cleanup

```bash
# delete the resources
helm uninstall hooks --no-hooks

# jump back to home directory `kubernetes_helm`:
cd -
```
