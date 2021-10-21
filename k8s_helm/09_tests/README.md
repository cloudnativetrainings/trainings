# Helm Test

In this task, you will learn how to test your Chart.

> Navigate to the directory `09_tests`, before getting started.

## Inspect the application

## Run the test

```bash
helm install my-app ./my-app 
```

```bash
helm test my-app
```

```bash
helm uninstall my-app
```

## Verify failing test

Adapt the URL in the test to something faulty.

```bash
helm install my-app ./my-app 
```

```bash
helm test my-app
```

Check the logfile of the test
```bash
kubectl logs my-app-test-<TAB>
```

## Cleanup
* Delete the release and resources
  ```bash
  helm uninstall my-app
  kubectl delete job my-app-test
  ```
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > ['required' Function](../08_required/README.md) | Next > [Hooks](../10_hooks/README.md)