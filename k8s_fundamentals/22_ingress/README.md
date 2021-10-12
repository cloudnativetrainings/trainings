# Ingress

In this training we will setup an Ingress and expose an app showing a blue screen and an app showing a red screen.

## Create the red application

```bash
kubectl create -f red.yaml
```

## Create the blue application

```bash
kubectl create -f blue.yaml
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

## Inspect and create the ingress

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

[Jump to Home](../README.md) | [Previous Training](../21_scheduling-taints-and-tolerations/README.md) | [Next Training](../23_cordon/README.md)