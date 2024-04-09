# Setup

In this task, we will setup the needed components for the class.

## Create Kubernetes Cluster

```bash
./00_setup/setup_cluster.sh
```

## Install Ingress

Store the IP Adress of the Ingress LB in an environment variable

```bash
export INGRESS_IP=$(gcloud compute addresses list --filter="region:europe-west6" \
                      --filter="name=training-kad-addr" --format="get(address)")
```

## Install Ingress

Install NGINX Ingress using Helm

```bash
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --version 4.9.0 \
  --set controller.service.loadBalancerIP=${INGRESS_IP}
```


## Install Monitoring components

First, install `kube-prometheus-stack` helm chart, which will install these components by default:

- Prometheus & Alertmanager
- Grafana
- kube-state-metrics
- node-exporter

```bash
helm upgrade --install monitoring kube-prometheus-stack \
  --repo https://prometheus-community.github.io/helm-charts \
  --namespace monitoring --create-namespace \
  --version 55.7.1 \
  --set grafana.ingress.enabled=true,grafana.ingress.ingressClassName=nginx
```

Get the username and password for grafana:

```bash
# username
kubectl get secret monitoring-grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 -d

# password
kubectl get secret monitoring-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 -d
```

You can reach Grafana using `http://${INGRESS_IP}`

## Install Logging components

Deploy `loki-stack`

> This chart deploys `promtail` by default. We changed it to fluent-bit

```bash
helm upgrade --install logging loki-stack \
    --repo https://grafana.github.io/helm-charts \
    --namespace logging --create-namespace \
    --version 2.10.0 \
    --set fluent-bit.enabled=true,promtail.enabled=false
```

You need to add Loki as a data source to the existing Grafana and then explore the logs.

> Hint: URL will be `http://logging-loki.logging.svc.cluster.local:3100`
>
> You may see an error on Grafana UI, but check the datasource on "Explore" tab.



# TODO readme kf und kfadmerge