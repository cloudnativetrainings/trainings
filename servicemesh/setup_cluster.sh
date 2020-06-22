#!/bin/bash

# variables
export PROJECT_NAME=loodse-training-playground
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
gcloud beta container clusters create $CLUSTER_NAME \
    --network $NETWORK_NAME  --create-subnetwork=name=$NETWORK_NAME-subnet,range=10.0.0.0/24 \
    --services-ipv4-cidr=10.0.1.0/24 --default-max-pods-per-node=110 \
    --zone=$ZONE \
    --cluster-version "1.14.10-gke.41" \
    --machine-type "n1-standard-4" --num-nodes "2" \
    --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "50" \
    --enable-network-policy --enable-ip-alias --no-enable-autoupgrade --no-enable-stackdriver-kubernetes \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing

### add firewall rule for node port range
# A common way for access applications in Kubernetes is to use [Service - Type NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport). This service type opens random ports on every node in the range `30000-32767`. On GKE clusters this port ranged is blocked by the [GCP VPC Firewall](https://console.cloud.google.com/networking/firewalls/list). To open the range in firewall we execute the following command:
gcloud compute firewall-rules create $FIREWALL_NAME-ingress-gateway \
--network $NETWORK_NAME \
--direction=INGRESS \
--action=ALLOW \
--source-ranges=0.0.0.0/0 \
--rules=tcp:80
### add ssh access for nodes
gcloud compute firewall-rules create $FIREWALL_NAME-ssh \
 --direction=INGRESS \
 --network=$NETWORK_NAME \
 --action=ALLOW \
  --source-ranges=0.0.0.0/0 \
  --rules=tcp:22

# connect to cluster
gcloud container clusters get-credentials $CLUSTER_NAME 
echo 'source <(kubectl completion bash)' >> ~/.bashrc && source ~/.bashrc

# verify
# kubectl run my-pod --generator run-pod/v1 --image nginx --port 80 -l app=my-pod
# kubectl expose pod my-pod --type NodePort
# export NODE=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[?(@.type=='ExternalIP')].address}")
# export PORT=$(kubectl get svc my-pod -o jsonpath="{.spec.ports[0].nodePort}")
# curl http://$NODE:$PORT
# kubectl delete pod,svc my-pod

# TODO setup automated DNS entries