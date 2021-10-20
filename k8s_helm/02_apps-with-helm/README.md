# Apps with Helm

In this task, we will use Helm for installing the app.

## Using a Helm Chart without customization

### Inspect the Helm Chart

### Show all installed Helm Releases

```bash
cd 02_apps-with-helm
helm ls
```

### Release the red application

```bash
helm install red ./color-viewer
```

### Verify your app

You can visit the red application on `http://$ENDPOINT/red`

```bash
helm ls
kubectl get all
```

## Doing a customized release

### Using inline Values

```bash
helm install green --set color=green ./color-viewer
```

You can visit the red application on `http://$ENDPOINT/green`


### Use a custom values file

```bash
helm install magenta ./color-viewer -f my-values.yaml 
```

You can visit the red application on `http://$ENDPOINT/magenta`

### Verify the installed components

```bash
helm ls
kubectl get all
```

### Cleanup
* Delete the releases
  ```bash
  helm uninstall red green magenta
  ```
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```
  
Jump > [Home](../README.md) | Previous > [Install Apps without Helm](../01_apps-without-helm/README.md) | Next > [Rollback](../03_rollback/README.md)