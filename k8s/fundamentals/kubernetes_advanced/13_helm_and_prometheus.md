# Helm and Prometheus

## Helm

In this course we will install Helm into our cluster and use it.

### 1. Install Helm

Install [Helm `v3`](https://helm.sh/docs/intro/install/) to your terminal machine.

```bash
curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

## ensure in cloud shell to be constant
cp `which helm` ~/bin/

## verify helm3
helm version

## add bash completion
echo 'source <(helm completion bash)' >> ~/.bashrc && bash
```

### 2. Add the stable Kubernetes repo

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
```

## Prometheus

### 1. Search for a Prometheus Chart via helm

```bash
helm search repo prometheus
```

### 2. Install Prometheus to your cluster into the namespace "monitoring"

```bash
kubectl create namespace monitoring
helm install my-prometheus --namespace monitoring stable/prometheus
```

### 3. Take a look at the installed resources

```bash
helm list -n monitoring
kubectl -n monitoring get all
```

### 4. Make Prometheus available from outside the cluster

Change the type of the Service to `NodePort`.

```bash
kubectl -n monitoring edit svc my-prometheus-server
```

### 5. Get the IP and the Port for Prometheus and use your browser to access it

```bash
## get the external IP address of the node
kubectl get nodes -o wide

## get the port of the application
kubectl -n monitoring get svc
```

### 6. Execute some query over the "graph" page in your browser

Call `http://NODE_IP:NODE_PORT/graph` in your browser.

* http requests: `http_requests_total`
* API server requests count: `http_requests_total{handler="prometheus",job="kubernetes-apiservers"}`
* per-second rate, messured over the last 5 min: `rate(http_requests_total[5m])`
* more examples: [https://prometheus.io/docs/prometheus/latest/querying/examples](https://prometheus.io/docs/prometheus/latest/querying/examples)

## Grafana

### 1. Install Grafana to your cluster into the "monitoring" namespace

```bash
helm install my-grafana --namespace monitoring stable/grafana
```

### 2. Make Grafana available from outside the cluster

Change the type of the Service to `NodePort`.

```bash
kubectl -n monitoring edit svc my-grafana
```

### 3. Get the IP and the Port for Grafana

```bash
## get the external IP address of the node
kubectl get nodes -o wide

## get the port of the application
kubectl -n monitoring get svc
```

### 4. Get the password for Grafana

```bash
## printout the secret
kubectl -n monitoring get secret my-grafana -o yaml

## decode the secret
echo <ADMIN-PASSWORD> | base64 -d
```

## 5. Add Prometheus as data source to Grafana

* Call `http://GRAFANA_IP:GRAFANA_PORT/` in your browser
* Choose the option `Create your first data source`
* Choose type `Prometheus`
* Insert URL `http://my-prometheus-server` and click `Save & Test`
* Choose the Option `Dashboards`/`Manage`/`Import`
* Paste the number 1860 into the field `Grafana.com Dashboard` and click `Load` (Visit [https://grafana.com/grafana/dashboards](https://grafana.com/grafana/dashboards) for other Dashboards)
* Choose the Datasource Prometheus in the field `Prometheus` and `Import` afterwards
* Investigate the Dashboard; take care to a proper time range via the button on the right above

## 6. Clean up

```bash
## list all installed helm charts
helm list -n monitoring

## uninstall charts
helm uninstall -n monitoring my-grafana
helm uninstall -n monitoring my-prometheus

## check namespace
kubectl -n monitoring get all
```
