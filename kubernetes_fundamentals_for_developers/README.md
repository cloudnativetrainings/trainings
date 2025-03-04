# Kubernetes Fundamentals for Developers

## Setup training environment

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com) via web browser.
1. Clone the Kubermatic trainings git repository: `git clone https://github.com/cloudnativetrainings/trainings.git`
1. Navigate to Kubernetes Fundamentals training folder to get started `cd trainings/kubernetes_fundamentals_for_developers/`
1. Create the cluster`make setup`
1. Persist the ingress IP
   ```bash
   export INGRESS_IP=$(gcloud compute addresses list --filter="name=training-ingress" --format="get(address)")
   echo "export INGRESS_IP=$INGRESS_IP" >> ~/.trainingrc
   ```
1. Bring in some convenience into training environment`source ~/.trainingrc`

## Verify training environment

```bash
make verify
```

## Access Grafana

For getting monitoring and logging infos you can access Grafana as follows

```bash
# get the IP address of the Grafana UI
export INGRESS_IP=$(gcloud compute addresses list --filter="name=training-ingress" --format="get(address)")
echo $INGRESS_IP

# get the username for the Grafana UI
kubectl get secret monitoring-grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 -d

# get the password for the Grafana UI
kubectl get secret monitoring-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 -d
```

## Teardown training environment

```bash
make teardown
```
