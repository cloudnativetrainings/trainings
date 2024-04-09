# Kubernetes Fundamentals for Developers

## Setup training environment

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com ) via web browser.

2. Clone the Kubermatic trainings git repository:

```bash
git clone https://github.com/kubermatic-labs/trainings.git
```

3. Navigate to Kubernetes Fundamentals training folder to get started

```bash
cd trainings/kubernetes_fundamentals_for_developers/
```

4. Create the cluster

```bash
make setup

source ~/.trainingrc
```

## Verify training environment

```bash
make verify
```

## Access Grafana

For getting monitoring and logging infos you can access Grafana as follows

```bash
# get the IP address of the Grafana UI
export INGRESS_IP=$(gcloud compute addresses list --filter="region:europe-west6"  --filter="name=training-kf-addr" --format="get(address)")
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
