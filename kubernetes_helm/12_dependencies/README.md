# Dependencies

In this task, you will learn about Dependencies.

> Navigate to the directory `$HOME/trainings/kubernetes_helm/12_dependencies`, before getting started.

## Inspect the Charts

Take a look athe `Chart.yaml` file. There is a dependency defined for the Chart called `my-dependency`.

```bash
tree

cat ./my-app/Chart.yaml
```

You can also inspect the dependencies via the following command.

```bash
helm dependency list ./my-app
```

## Update the dependencies

```bash
helm dependency update ./my-app
```

> Note that the `Charts.lock` file and the `charts` directory got created in the Chart `my-app`.

```bash
# note that the dependency is also in state OK now
helm dependency list ./my-app
```

## Install a chart with its dependencies

### Not installing the dependency

Inspect the dependency in the file `Chart.yaml`. It is enabled depending on a Value. Take a look at the file `values.yaml` on how to set this Value.

```bash
cat ./my-app/Chart.yaml

cat ./my-app/values.yaml
```

Install the app with its default values.

```bash
helm install app my-app
```

Wait until the pods are ready

```bash
kubectl wait pod -l app=my-app --for=condition=ready --timeout=120s
```

Verify that the dependency was not installed

```bash
kubectl exec -it my-app -- curl http://my-dependency
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
kubectl exec -it my-app -- curl http://my-dependency
```

Uninstall the app again

```bash
helm uninstall app
```

### Override values of the SubChart

Check the values of the subchart values.yaml:

```bash
cat ./my-dependency/values.yaml
```

Install the app with the dependency enabled.

```bash
helm install app my-app --set my-dependency.enabled=true --set my-dependency.content="Bonjour Helm"
```

Wait until the pods are ready

```bash
kubectl wait pod -l app=my-app --for=condition=ready --timeout=120s
kubectl wait pod -l app=my-dependency --for=condition=ready --timeout=120s
```

Verify that the dependency was installed

```bash
kubectl exec -it my-app -- curl http://my-dependency
```

## Cleanup

```bash
# delete the resources
helm uninstall app

# jump back to home directory `kubernetes_helm`:
cd -
```
