# Setup

In this task we will setup the needed components for the training.

## Create Kubernetes Cluster

```bash
./setup_cluster.sh
```
## Install Ingress

```bash
# Create the namespace
kubectl create ns ingress-controller

# Create the ingress-controller
kubectl create -f ingress-controller
```

## Store the IP Adress of the Ingress LB in an environment variable

```bash
# Note it may take some time to get the EXTERNAL-IP
kubectl -n ingress-controller get svc

export ENDPOINT=$(kubectl -n ingress-controller get svc traefik-ingress-service -o jsonpath="{.status.loadBalancer.ingress[0].ip}") 
```

## Verify Ingress is running

Visit the Ingress Admin Port in your browser on `http://<ENDPOINT>:8080`
