# Dependencies

In this task, you will learn about Dependencies.

> Navigate to the directory `11_dependencies`, before getting started.

## Inspect the Charts

Take a look athe `Chart.yaml` file. There is a dependency defined for the Chart called `my-dependency`.

You can also inspect the dependencies via the following command.
```bash
helm dependency list ./my-app 
```

## Update the dependencies

```bash
helm dependency update ./my-app
```
> Note that the `Charts.lock` file and the `charts` directory got created in the Chart `my-app`.

## Install a chart with its dependencies

### Not installing the dependency

Inspect the dependency in the file `Chart.yaml`. It is enabled depending on a Value. Take a look at the file `values.yaml` on how to set this Value.

Install the app with its default values.
```bash
helm install app my-app
```

Verify that the dependency was not installed
```bash
kubectl exec -it my-app -- /bin/sh
curl my-dependency
```

Uninstall the app again
```bash
helm uninstall app
```

### Installing the dependency

Install the app with the dependency enabled.
```bash
helm install app my-app --set my-dependency.enabled=true
```

Verify that the dependency was installed
```bash
kubectl exec -it my-app -- /bin/sh
curl my-dependency
```

Uninstall the app again
```bash
helm uninstall app
```

### Override values of the SubChart

Install the app with the dependency enabled.
```bash
helm install app my-app --set my-dependency.enabled=true --set my-dependency.content="Bonjour Helm"
```

Verify that the dependency was installed
```bash
kubectl exec -it my-app -- /bin/sh
curl my-dependency
```

## Cleanup 
* Delete the release
  ```bash
  helm uninstall app
  ```
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > [Hooks](../10_hooks/README.md) | Next > [Teardown](../99_teardown/README.md)