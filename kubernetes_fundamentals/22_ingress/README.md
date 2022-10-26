# Ingress

In this training, we will setup an Ingress and expose an app showing a blue screen and an app showing a red screen.

>Navigate to the folder `22_ingress` from CLI, before you get started. 

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
> Before you start, create role binding 

```bash
# Make sure you update your username
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=student-xx.yyy@loodse.training
```

```bash
# Install NGINX Ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.4.0/deploy/static/provider/cloud/deploy.yaml
```

## Verify everything is running

```bash
kubectl get deployments,pods,services

# to view nginx-ingress related stuff
kubectl get deployments,pods,services -n ingress-nginx
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
kubectl get svc ingress-nginx-controller -n ingress-nginx
```
Get the external IP of your LoadBalancer and vist via web browser as follows
* `http://<EXTERNAL-IP>/red`
* `http://<EXTERNAL-IP>/blue`

## Clean up

```bash
kubectl delete -f .
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.4.0/deploy/static/provider/cloud/deploy.yaml
```

[Jump to Home](../README.md) | [Previous Training](../21_scheduling-taints-and-tolerations/README.md) | [Next Training](../23_cordon/README.md)