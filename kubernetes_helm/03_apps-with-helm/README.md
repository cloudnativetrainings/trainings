# Apps with Helm

In this task, we will use Helm for installing the app.

## Using a Helm Chart without customization

### Inspect the Helm Chart

```bash
cd $HOME/trainings/kubernetes_helm/03_apps-with-helm
tree color-viewer
```

You will see 2 important files and a directory with manifests.

- Chart.yaml: Contains information about the chart
- values.yaml: Contains customizable values to be used in templates
- templates/\*.yaml: Manifest files with some go templating to be customized

Check the default values of the chart:

```bash
cat color-viewer/values.yaml
```

### Show all installed Helm Releases

```bash
helm ls
```

## Check the templating result

This command will show which manifest files will be deployed with default values:

```bash
helm template ./color-viewer
```

Change a value and check again:

```bash
helm template ./color-viewer --set replicas=3
```

## Deploy dev

Deploy your application with Helm:

```bash
helm install demo-app ./color-viewer --namespace=dev --create-namespace
```

Checkout the status of the installation:

```bash
helm ls -A
```

Checkout the pods and verify that the application is running:

```bash
# Wait until the pod is ready:
kubectl get pods -n dev

curl http://${ENDPOINT}/dev
```

## Deploy prod

Checkout the values for production:

```bash
cat prod-values.yaml
```

Deploy your application with Helm:

```bash
helm install demo-app ./color-viewer --namespace=prod --create-namespace -f prod-values.yaml
```

Checkout the status of the installation:

```bash
helm ls -A
```

Checkout the pods and verify that the application is running. There must be 3 pods running.

```bash
# Wait until the pod is ready:
kubectl get pods -n prod

curl http://${ENDPOINT}/prod
```

### Cleanup

```bash
# delete the releases
helm uninstall demo-app -n dev
helm uninstall demo-app -n prod

# jump back to home directory `kubernetes_helm`:
cd -
```
