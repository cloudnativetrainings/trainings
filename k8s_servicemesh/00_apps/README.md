# Build and containerize the apps

## Build and push the image for the app `backend`

```bash
./build_backend.sh
```

## Build and push the image for the app `frontend`

```bash
./build_frontend.sh
```

## Create our training namespace in which istio injection is enabled

```bash
kubectl create -f ./namespace/namespace.yaml
```
