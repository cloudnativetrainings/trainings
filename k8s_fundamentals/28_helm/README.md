# Helm

In this training, we will use Helm to create and customize an application.

>Navigate to the folder `28_helm` from CLI, before you get started. 

## Verify if helm is installed
* Check helm
  ```bash
  helm version
  ```

* Ensure autocompletion is installed
  ```bash
  echo 'source <(helm completion bash)' >> ~/.bashrc && bash
  ```

## [Optional] Install helm

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Do a release

* Show all releases
  ```bash
  helm ls
  ```

* Release with its default values
  ```bash
  helm install my-release-defaults ./my-chart
  ```

* Show all releases
  ```bash
  helm ls
  ```

* Show kubernetes resources
  ```bash
  kubectl get all
  ```

* Delete a release
  ```bash
  helm delete my-release-defaults
  ```

## Do a customized release

* Release with a custom values.yaml file
  ```bash
  helm install my-release-custom ./my-chart -f my-values.yaml 
  ```

* Show all installed charts
  ```bash
  helm ls
  ```

* Show kubernetes resources
  ```bash
  kubectl get all
  ```

## Upgrade a release

* Change the color in the file `my-values.yaml` to re-release
  ```bash
  helm upgrade my-release-custom ./my-chart -f my-values.yaml
  ```

* Show all releases
  ```bash
  helm ls
  ```

* Show kubernetes resources
  ```bash
  kubectl get all
  ```

## Templating

* Add templating for the deployment in the file ./my-chart/templates/deployment.yaml
  ```yaml
  ...
  spec:
  replicas: {{ .Values.replicas }}
  selector:
  ...
  ```

## Customize your new release

* Add the replicas to the file my-values.yaml.
  ```yaml
  color: magenta
  replicas: 3
  ```

## Release

* Re-release 
  ```bash
  helm upgrade my-release-custom ./my-chart -f my-values.yaml
  ```

* Show all releases
  ```bash
  helm ls
  ```

* Show kubernetes resources
  ```bash
  kubectl get pods
  ```

## Tips & Tricks

* Render yaml files without deploying them
  ```bash
  helm install my-chart ./my-chart --dry-run > dry.run
  ```

* Lint your charts
  ```bash
  helm lint ./my-chart
  ```

## Cleanup

```bash
helm delete my-release-custom
```

[Jump to Home](../README.md) | [Previous Training](../27_networkpolicies/README.md) | [Next Training](../29_prometheus/README.md)