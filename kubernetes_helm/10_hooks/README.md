# Writing Hooks

In this task, you will learn how to write Hooks.

> Navigate to the directory `10_hooks`, before getting started.

## Inspect the Chart

Take a look at the Hooks.

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

* Delete the release
  ```bash
  helm uninstall hooks
  ```

## Disabling Hooks

Hooks can block the install/uninstall process, if they eg are in state `CrashLoopBackOff`. You can disable via the following.

```bash
helm install hooks ./my-app --no-hooks
```

## Cleanup
* Delete the release
  ```bash
  helm uninstall hooks --no-hooks
  ```
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > [Helm Test](../09_tests/README.md) | Next > [Dependencies](../11_dependencies/README.md)