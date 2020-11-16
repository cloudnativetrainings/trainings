# Build and containerize the apps

## Build and push the image for the app `backend`

```bash
./backend/build.sh
```

## Build and push the image for the app `frontend`

```bash
./frontend/build.sh
```

## Create our training namespace in which istio injection is enabled

```bash
kubectl create -f ./namespace/namespace.yaml
```
