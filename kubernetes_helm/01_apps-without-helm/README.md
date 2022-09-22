# Apps without Helm

In this task, we will take a look at working without Helm.

## Inspect the yaml files in the blue and red directorys.

## Create the blue app

```bash
cd 01_apps-without-helm
kubectl create -f blue
```
Afterwards, you can visit the app via the browser on `http://$ENDPOINT/blue`

## Create the red app

```bash
kubectl create -f red
```
Afterwards, you can visit the app via the browser on `http://$ENDPOINT/red`

## How long will it take to make a green app?

## Cleanup
* Delete the created resources
  ```bash
  kubectl delete -f blue,red
  ```
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > [Cluster Setup](../00_setup/README.md) | Next > [Install Apps with Helm](../02_apps-with-helm/README.md)