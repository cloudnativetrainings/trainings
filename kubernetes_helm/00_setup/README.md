# Setup

In this lab, we will setup the needed components for the training.

## Create Kubernetes Cluster

```bash
cd $HOME/trainings/kubernetes_helm/00_setup
./setup_cluster.sh
```

## Store the IP Adress of the Ingress LB in an environment variable

```bash
export ENDPOINT=$(gcloud compute addresses list --filter="region:europe-west3" --filter="name=training-kh-addr" --format="get(address)")
```

## Install Ingress

```bash
# Install NGINX Ingress via Helm
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --version 4.9.0 \
  --set controller.service.loadBalancerIP=${ENDPOINT}
```

## Verify Ingress is running

Visit the Ingress Admin Port using below curl command or in your browser on `http://$ENDPOINT:80`
> You will get `404 Not Found`
```bash
curl http://$ENDPOINT:80
```

## Cleanup

```bash
# jump back to home directory `kubernetes_helm`
cd -
```
