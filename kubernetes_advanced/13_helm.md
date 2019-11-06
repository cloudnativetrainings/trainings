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
helm install --namespace monitoring stable/prometheus
```
6. Take a look at the installed resources
```bash
kubectl -n monitoring get all 
```
7. Make Prometheus available from outside the cluster
```bash
kubectl -n monitoring edit svc prometheus-server
```
8. Get the IP and the Port for Prometheus and use your Browser to access it.
```bash
# Get the external IP address of the node
kubectl get nodes -o wide
# Get the port of the application
kubectl get services
```


