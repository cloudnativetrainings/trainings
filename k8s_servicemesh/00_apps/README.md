# Setup apps

## Build and push the application images

```bash
./build_backend_1.0.0.sh
./build_frontend_1.0.0.sh
./build_frontend_2.0.0.sh
```

## Create our training namespace in which istio injection is enabled

```bash
kubectl create -f ./namespace.yaml
```

## Switch to the namespace `training`

```bash
kubens training
```

## Export the public ip of the istio-ingressgateway

```bash
export INGRESS_HOST=$(kubectl -n istio-system get svc istio-ingressgateway -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
```
