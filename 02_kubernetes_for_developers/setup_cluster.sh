#!/bin bash

# variables
export PROJECT_NAME=ps-workspace
export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=training-loodse
export NETWORK_NAME=$CLUSTER_NAME
export FIREWALL_NAME=$CLUSTER_NAME

# set gcloud params
gcloud config set project $PROJECT_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# create networks
gcloud compute networks create $NETWORK_NAME --subnet-mode=custom

# create cluster
gcloud beta container clusters create training \
    --network $NETWORK_NAME  --create-subnetwork=name=$NETWORK_NAME-subnet,range=10.0.0.0/24 \
    --services-ipv4-cidr=10.0.1.0/24 --default-max-pods-per-node=110 \
    --zone=$ZONE \
    --cluster-version "1.15.11-gke.11" \
    --machine-type "n1-standard-4" --num-nodes "2" \
    --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "50" \
    --enable-network-policy --enable-ip-alias --no-enable-autoupgrade --no-enable-stackdriver-kubernetes \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing

# add firewall rule
gcloud compute firewall-rules create $FIREWALL_NAME \
--network $NETWORK_NAME \
--direction=INGRESS \
--action=ALLOW \
--source-ranges=0.0.0.0/0 \
--rules=tcp:30000-32767 

# connect to cluster
gcloud container clusters get-credentials $CLUSTER_NAME 
source <(kubectl completion bash)

# verify
kubectl run my-pod --generator run-pod/v1 --image nginx --port 80 -l app=my-pod
kubectl expose pod my-pod --type NodePort
export NODE=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[?(@.type=='ExternalIP')].address}")
export PORT=$(kubectl get svc my-pod -o jsonpath="{.spec.ports[0].nodePort}")
curl http://$NODE:$PORT
kubectl delete pod,svc my-pod
```

# Teardown
```bash
gcloud beta container clusters delete training
gcloud compute firewall-rules delete training
```
