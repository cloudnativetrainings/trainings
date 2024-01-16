# Rolling back a release

In this task, we will rollback a release.

### Inspect the Helm Chart

```bash
cd $HOME/trainings/kubernetes_helm/04_rollback

tree color-viewer

cat color-viewer/values.yaml
```

## Release the red app

```bash
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

## History and changes

Take a look at the history of my-app
```bash
helm history my-app
```

Check the values on this current release:

```bash
helm get values my-app --all
```

Previous release:

```bash
helm get values my-app --all --revision 1
```

## Rollback

Rollback to the first revision

```bash
helm rollback my-app 1
```

Check the history again

```bash
helm history my-app
```

You can visit the app on `http://$ENDPOINT/red`

## Cleanup
* Delete the resources
  ```bash
  helm uninstall my-app
  ```
* Jump back to home directory `kubernetes_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > [Install Apps with Helm](../03_apps-with-helm/README.md) | Next > [Variables](../05_variables/README.md)