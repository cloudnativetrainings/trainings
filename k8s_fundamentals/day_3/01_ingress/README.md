# Ingress

In this training we will setup an Ingress.

## Inspect the [red yaml file](./red.yaml) and create the red pod and service

```bash
kubectl create -f red.yaml

# Patch the nginx container
kubectl cp red.html red:/usr/share/nginx/html/index.html
```

## Inspect the [blue yaml file](./blue.yaml) and create the blue pod and service

```bash
kubectl create -f blue.yaml

# Patch the nginx container
kubectl cp blue.html blue:/usr/share/nginx/html/index.html
```

## Verify your steps

```bash
kubectl get pods,svc
```

## Inspect and create the resources for the ingress controller

```bash
kubectl create -f ingress-controller-rbac.yaml
kubectl create -f ingress-controller-deployment.yaml
kubectl create -f ingress-controller-service.yaml
```

## Verify everything is running

```bash
kubectl get deployments,pods,services
```

## Inspect and create your ingress routes

```bash
kubectl create -f ingress.yaml
```

## Verify your steps

```bash
kubectl describe ing my-ingress
```

## Visit the applications "red" and "blue" in your browser via

```bash
# Get the external IP of your LoadBalancer
kubectl get svc traefik-ingress-service
```

* `http://<EXTERNAL-IP>/red`
* `http://<EXTERNAL-IP>/blue`

## Clean up

```bash
kubectl delete -f .
```
