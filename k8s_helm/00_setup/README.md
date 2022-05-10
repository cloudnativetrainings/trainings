# Setup

In this task, we will setup the needed components for the training.


## Create Kubernetes Cluster

```bash
cd k8s_helm/00_setup
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
  > - With serviceaccount (optional, if no google cloud shell is used) -> using `gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/container.admin'` where set the values of parameters `GCP_PROJECT_ID` to your project and `GCP_SERVICE_ACCOUNT_ID` to your service account.
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

Visit the Ingress Admin Port using below curl command or in your browser on `http://$ENDPOINT:8080`
```bash
curl http://$ENDPOINT:8080
```

## Cleanup 
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Next > [Install Apps without Helm](../01_apps-without-helm/README.md)