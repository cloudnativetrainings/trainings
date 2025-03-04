# Variables

In this task, we will add a variable to our Helm Chart.

> Navigate to folder `$HOME/trainings/kubernetes_helm/05_variables` before getting started

## Add templating for the deployment

Update the file `./color-viewer/templates/deployment.yaml` as below:

```yaml
spec:
  replicas: { { .Values.replicas } }
  selector:
```

## Add the default value for the variable `replicas`

Add the following line in the file `./color-viewer/values.yaml`

```yaml
replicas: 1
```

## Make use of your new variable

```bash
helm install my-app --set replicas=3 ./color-viewer
```

Verify the number of pods via

```bash
kubectl get pods
```

## Cleanup

```bash
# delete the resources
helm uninstall my-app

# jump back to home directory `kubernetes_helm`:
cd -
```
