# Variables

In this task, we will add a variable to our Helm Chart.

> Navigate to folder `04_variables` before getting started

## Add templating for the deployment in the file ./color-viewer/templates/deployment.yaml

```yaml
...
spec:
  replicas: {{ .Values.replicas }}
  selector:
...  
```

## Add the default value for the variable `replicas`

Add the following line in the file ./color-viewer/values.yaml
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
* Delete the release
  ```bash
  helm uninstall my-app
  ```
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > [Rollback](../03_rollback/README.md) | Next > [Functions](../05_functions/README.md)