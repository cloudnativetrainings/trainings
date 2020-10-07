# Prometheus

## Create a pod

```bash
kubectl create -f pod.yaml
```

## Add the stable kubernetes repo

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
```

## Prometheus

### Search for a prometheus chart via helm

```bash
helm search repo prometheus
```

### Install prometheus

```bash
helm install my-prometheus stable/prometheus -f prometheus-values.yaml 
```

### Take a look at the installed resources

```bash
helm list
kubectl get all
```

### Visit the prometheus UI in the browser

```bash
# Get the External IP of the service
kubectl get svc
```

### Execute some query over the "graph" page in your browser

* http requests: `container_memory_usage_bytes`
* API server requests count: `container_memory_usage_bytes{pod="my-pod",container="nginx"}`
* per-second rate, messured over the last 5 min: `rate(container_memory_usage_bytes{pod="my-pod",container="nginx"}[5m])`
* predict memory usage in 24 hours based on the rate of the last 5 minutes: `predict_linear((container_memory_usage_bytes{pod="my-pod",container="nginx"}[5m]),24*3600)`
* more examples: [https://prometheus.io/docs/prometheus/latest/querying/examples](https://prometheus.io/docs/prometheus/latest/querying/examples)

## Grafana

### Install grafana

```bash
helm install my-grafana stable/grafana -f grafana-values.yaml
```

### Visit the grafana UI in the browser

```bash
# Get the External IP of the service
kubectl get svc
```

## Add Prometheus as data source to Grafana

* Choose the option `Create your first data source`
* Choose type `Prometheus`
* Insert URL `http://my-prometheus-server` and click `Save & Test`
* Choose the Option `Dashboards`/`Manage`/`Import`
* Paste the number 1860 into the field `Grafana.com Dashboard` and click `Load` (Visit [https://grafana.com/grafana/dashboards](https://grafana.com/grafana/dashboards) for other Dashboards)
* Choose the Datasource Prometheus in the field `Prometheus` and `Import` afterwards
* Investigate the Dashboard; take care to a proper time range via the button on the right above

## Clean up

```bash
helm delete my-grafana
helm delete my-prometheus
kubectl delete pod my-pod
```
