# Helm
In this course we will install Helm into our cluster and use it.

1. Install Helm to your Terminal machine
```bash
curl -L https://git.io/get_helm.sh | bash
```
2. Create the RBAC resources for needed for Helm
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
```
```bash
kubectl apply -f rbac.yaml
```
3. Install Helm to your cluster.
```bash
helm init --service-account=tiller --history-max 300
```
4. Search for a Prometheus Chart via helm
```bash
helm search prometheus
```
5. Install Prometheus to your cluster into the namespace `monitoring`
```bash
helm install --name my-prometheus --namespace monitoring stable/prometheus
```
6. Take a look at the installed resources
```bash
kubectl -n monitoring get all 
```
7. Make Prometheus available from outside the cluster. Change the type of the Service to `NodePort`
```bash
kubectl -n monitoring edit svc my-prometheus-server 
```
8. Get the IP and the Port for Prometheus and use your Browser to access it.
```bash
# Get the external IP address of the node
kubectl get nodes -o wide
# Get the port of the application
kubectl -n monitoring get svc
```
9. Install Grafana to your cluster into the namespace `monitoring`
```bash
helm install --name my-grafana --namespace monitoring stable/grafana
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
15. Insert URL `http://my-prometheus-server`
16. Choose the Option `Dashboards`/`Manage`/`Import`
17. Paste the number 1860 into the field `Grafana.com Dashboard` and click `Load` (Visit https://grafana.com/grafana/dashboards for other Dashboards)
18. Choose the Datasource Prometheus in the field `Prometheus` and `Import` afterwards.
19. Investigate the Dashboard. Take care to a proper time range via the button on the right above.
