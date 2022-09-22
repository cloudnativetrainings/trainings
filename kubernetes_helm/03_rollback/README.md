# Rolling back a release

In this task, we will rollback a release.

### Inspect the Helm Chart

## Release the red app

```bash
cd 03_rollback
helm install my-app ./color-viewer
```

You can visit the red application on `http://$ENDPOINT/red`

## Upgrade the red app

```bash
helm upgrade my-app --set color=blue ./color-viewer
```

You can visit the app on `http://$ENDPOINT/blue`

Take a look at the Helm releases
```bash
helm ls
```

## Rollback to the previous version of my-app

Take a look at the history of my-app
```bash
helm history my-app
```

```bash
helm rollback my-app 1
```

You can visit the app on `http://$ENDPOINT/red`

## Cleanup
* Delete the resources
  ```bash
  helm uninstall my-app
  ```
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > [Install Apps with Helm](../02_apps-with-helm/README.md) | Next > [Variables](../04_variables/README.md)