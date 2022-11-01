# Setup

In this task, we will setup the needed components for the training.


## Create Kubernetes Cluster

```bash
cd k8s_helm/00_setup
./setup_cluster.sh
```

## Install Ingress
> Before you start, create role binding

```bash
# Make sure you update your username
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=student-xx.yyy@loodse.training
```

```bash
# Install NGINX Ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.4.0/deploy/static/provider/cloud/deploy.yaml
```

## Store the IP Adress of the Ingress LB in an environment variable

```bash
kubectl -n ingress-nginx get svc
```
>Note that it may take some time to get the EXTERNAL-IP
```bash
export ENDPOINT=$(kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
```

## Verify Ingress is running

Visit the Ingress Admin Port using below curl command or in your browser on `http://$ENDPOINT:80`
> You will get `404 Not Found`
```bash
curl http://$ENDPOINT:80
```

## Cleanup 
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Next > [Install Apps without Helm](../01_apps-without-helm/README.md)
