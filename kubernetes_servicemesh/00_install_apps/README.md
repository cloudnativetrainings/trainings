# Setup apps

## Navigate to project folder to install the applications we would use before the addons
```bash
cd 00_install_apps
```

## Build and push the application images

```bash
./build_backend_1.0.0.sh
./build_frontend_1.0.0.sh
./build_frontend_2.0.0.sh
```

## Create our training namespace in which istio injection is enabled

```bash
kubectl create -f k8s/namespace.yaml
```

## Switch to the namespace `training`

```bash
kubens training
```

## Create the Deployments and Services

```bash
kubectl create -f ./k8s
```

## Export the public ip of the istio-ingressgateway

```bash
export INGRESS_HOST=$(kubectl -n istio-system get svc istio-ingressgateway -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
```
