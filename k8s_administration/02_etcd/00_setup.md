# Connect to the instance controller-0

```bash
gcloud compute ssh master-0
```

# Ensure you can talk to the cluster

```bash
export KUBECONFIG=~/admin.kubeconfig
kubectl get nodes
```