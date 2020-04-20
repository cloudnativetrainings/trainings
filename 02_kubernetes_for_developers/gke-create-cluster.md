# Create an GKE cluster

```bash
# set gcloud params
gcloud config set project <PROJECT-ID>
gcloud config set compute/region europe-west3
gcloud config set compute/zone europe-west3-a

# create cluster
gcloud beta container clusters create training \
    --cluster-version "1.15.11-gke.5" \
    --machine-type "n1-standard-4" --num-nodes "2" \
    --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "50" \
    --enable-network-policy --enable-pod-security-policy --enable-ip-alias --no-enable-autoupgrade \
    --addons HorizontalPodAutoscaling 

# add firewall rule
gcloud compute firewall-rules create training \
--priority=500 \
--network=default \
--direction=INGRESS \
--action=ALLOW \
--source-ranges=0.0.0.0/0 \
--rules=tcp:30000-32767 

# connect to cluster
gcloud container clusters get-credentials training 

# verify
kubectl run my-pod --generator run-pod/v1 --image nginx --port 80 -l app=my-pod
kubectl expose pod my-pod --type NodePort
NODE=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[?(@.type=='ExternalIP')].address}")
PORT=$(kubectl get svc my-pod -o jsonpath="{.spec.ports[0].nodePort}")
curl http://$NODE:$PORT
kubectl delete pod,svc my-pod
```

***WARNING:*** This lowers the security level of an Kubernetes clusters, so this should not be used for productive clusters!

# Teardown of the Cluster
```bash
gcloud beta container clusters delete training
gcloud compute firewall-rules delete training
```