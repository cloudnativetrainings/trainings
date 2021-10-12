# Helm

In this training we will use Helm to create and customize an application.

## Verify if helm is installed

```bash
## Check helm
helm version

## Ensure autocompletion is installed
echo 'source <(helm completion bash)' >> ~/.bashrc && bash
```

## [Optional] Install helm

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Do a release

```bash
# Show all releases
helm ls

# Release with its default values
helm install my-release-defaults ./my-chart

# Show all releases
helm ls

# Show kubernetes resources
kubectl get all

# Delete a release
helm delete my-release-defaults
```

## Do a customized release

```bash
# Release with a custom values.yaml file
helm install my-release-custom ./my-chart -f my-values.yaml 

# Show all installed charts
helm ls

# Show kubernetes resources
kubectl get all
```

## Upgrade a release

```bash
# Change the color in the file `my-values.yaml`

# Re-release 
helm upgrade my-release-custom ./my-chart -f my-values.yaml 

# Show all releases
helm ls

# Show kubernetes resources
kubectl get all
```

## Templating

### Add templating for the deployment in the file ./my-chart/templates/deployment.yaml

```yaml
...
spec:
  replicas: {{ .Values.replicas }}
  selector:
...  
```

### Customize your new release

Add the replicas to the file my-values.yaml.

```yaml
color: magenta
replicas: 3
```

### Release

```bash
# Re-release 
helm upgrade my-release-custom ./my-chart -f my-values.yaml 

# Show all releases
helm ls

# Show kubernetes resources
kubectl get pods
```

## Tips & Tricks

```bash
# Render yaml files without deploying them
helm install my-chart ./my-chart --dry-run > dry.run

# Lint your charts
helm lint ./my-chart
```

## Cleanup

```bash
helm delete my-release-custom
```

[Jump to Home](../README.md) | [Previous Training](../27_networkpolicies/README.md) | [Next Training](../29_prometheus/README.md)