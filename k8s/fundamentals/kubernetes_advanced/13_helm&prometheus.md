# Helm
In this course we will install Helm into our cluster and use it.

1. Install [Helm `v3`](https://helm.sh/docs/intro/install/) to your Terminal machine
```bash
curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
### verify helm3
helm verision
### add bash completion
echo 'source <(helm completion bash)' >> ~/.bashrc && source ~/.bashrc
```

2. Add the stable Kubernetes repo
```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
```

## Prometheus

3. Search for a Prometheus Chart via helm
```bash
helm search repo prometheus
```

4. Install Prometheus to your cluster into the namespace `monitoring`
```bash
kubectl create namespace monitoring
helm install my-prometheus --namespace monitoring stable/prometheus
```

5. Take a look at the installed resources
```bash
helm list -n monitoring
kubectl -n monitoring get all 
```

6. Make Prometheus available from outside the cluster. Change the type of the Service to `NodePort`
```bash
kubectl -n monitoring edit svc my-prometheus-server 
```

7. Get the IP and the Port for Prometheus and use your Browser to access it.
```bash
# Get the external IP address of the node
kubectl get nodes -o wide
# Get the port of the application
kubectl -n monitoring get svc
```

8. Execute some query over the `/graph` page in your browser: `http://NODE_IP:NODE_PORT/graph`.
- http requests: `http_requests_total`
- API server requests count: `http_requests_total{handler="prometheus",job="kubernetes-apiservers"}`
- per-second rate, messured over the last 5 min: `rate(http_requests_total[5m])`
- more examples: https://prometheus.io/docs/prometheus/latest/querying/examples

## Grafana

9. Install Grafana to your cluster into the namespace `monitoring`
```bash
helm install my-grafana --namespace monitoring stable/grafana
```

10. Make Grafana available from outside the cluster. Change the type of the Service to `NodePort`
```bash
kubectl -n monitoring edit svc my-grafana
```
11. Get the IP and the Port for Grafana and use your Browser to access it.
```bash
# Get the external IP address of the node
kubectl get nodes -o wide
# Get the port of the application
kubectl -n monitoring get svc
```
12. Get the Password for Grafana
```bash
# Printout the secret
kubectl -n monitoring get secret my-grafana -o yaml
# Decode the secret
echo <ADMIN-PASSWORD> | base64 -d
```
13. Choose the option `Create your first data source`
14. Choose type `Prometheus`
15. Insert URL `http://my-prometheus-server` and click `Save & Test`
16. Choose the Option `Dashboards`/`Manage`/`Import`
17. Paste the number 1860 into the field `Grafana.com Dashboard` and click `Load` (Visit https://grafana.com/grafana/dashboards for other Dashboards)
18. Choose the Datasource Prometheus in the field `Prometheus` and `Import` afterwards.
19. Investigate the Dashboard. Take care to a proper time range via the button on the right above.

## Clean up
```bash
# list all installed helm charts
helm list -n monitoring
# uninstall charts
helm uninstall -n monitoring my-grafana
helm uninstall -n monitoring my-prometheus
# check namespace
kubectl -n monitoring get all 
```
