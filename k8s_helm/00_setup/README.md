# Setup

In this task, we will setup the needed components for the training.

## Create Kubernetes Cluster

```bash
./setup_cluster.sh
```
## Install Ingress

* Create the namespace
  ```bash
  kubectl create ns ingress-controller
  ```

* Create the ingress-controller
  > Before you start, create role binding 
  > - With user account -> using `gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member user:$GCP_USER_ACCOUNT --role='roles/container.admin'` where set the values of parameters `GCP_PROJECT_ID` to your project and `GCP_USER_ACCOUNT` to your user account.
  > - With serviceaccount -> using `gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/container.admin'` where set the values of parameters `GCP_PROJECT_ID` to your project and `GCP_SERVICE_ACCOUNT_ID` to your service account.
  ```bash
  kubectl create -f ingress-controller
  ```

## Store the IP Adress of the Ingress LB in an environment variable

```bash
kubectl -n ingress-controller get svc
```
>Note that it may take some time to get the EXTERNAL-IP
```bash
export ENDPOINT=$(kubectl -n ingress-controller get svc traefik-ingress-service -o jsonpath="{.status.loadBalancer.ingress[0].ip}") 
```

## Verify Ingress is running

Visit the Ingress Admin Port in your browser on `http://<ENDPOINT>:8080`

Jump > [Home](../README.md) | Next > [Install Apps without Helm](../01_apps-without-helm/README.md)