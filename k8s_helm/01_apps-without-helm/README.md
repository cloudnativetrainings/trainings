# Apps without Helm

In this task we will take a look at working without Helm.

## Inspect the yaml files in the blue and red directorys.

## Create the blue app

```bash
kubectl create -f blue
```

Afterwards you can visit the app via the browser on `http://<ENDPOINT>/blue`

## Create the red app

```bash
kubectl create -f red
```

Afterwards you can visit the app via the browser on `http://<ENDPOINT>/red`

## How long will it take to make a green app?

## Cleanup

```bash
kubectl delete -f blue,red
```