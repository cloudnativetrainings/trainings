# Variables

In this task we will add a variable to our Helm Chart.

## Add templating for the deployment in the file ./my-chart/templates/deployment.yaml

```yaml
...
spec:
  replicas: {{ .Values.replicas }}
  selector:
...  
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
helm delete my-app
```