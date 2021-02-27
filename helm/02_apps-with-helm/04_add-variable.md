# Templating

## Add templating for the deployment in the file ./my-chart/templates/deployment.yaml

```yaml
...
spec:
  replicas: {{ .Values.replicas }}
  selector:
...  
```

## Install

```bash
# Re-release 
helm install my-app --set replicas=3 ./color-viewer

# Show all releases
helm ls

# Show kubernetes resources
kubectl get pods
```

## Cleanup

```bash
helm delete my-app
```