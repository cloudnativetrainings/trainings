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
> - With user account -> using `gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member user:$GCP_USER_ACCOUNT --role='roles/container.admin'` where set the values of parameters `GCP_PROJECT_ID` to your project and `GCP_USER_ACCOUNT` to your user account.
> - With serviceaccount -> using `gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/container.admin'` where set the values of parameters `GCP_PROJECT_ID` to your project and `GCP_SERVICE_ACCOUNT_ID` to your service account.
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
kubectl get svc traefik-ingress-service
```
Get the external IP of your LoadBalancer and vist via web browser as follows
* `http://<EXTERNAL-IP>/red`
* `http://<EXTERNAL-IP>/blue`

## Clean up

```bash
kubectl delete -f .
```

[Jump to Home](../README.md) | [Previous Training](../21_scheduling-taints-and-tolerations/README.md) | [Next Training](../23_cordon/README.md)