# Create Master/Seed Kubernetes Cluster

```bash
cd ~/02_create_kubeone_cluster/
```

## Create infrastructure

```bash
make terraform

# Inspect the file ~/kubeone/tf.json

gcloud compute instances list
```

## Create Cluster

```bash
make create_cluster

gcloud compute instances list
```

## Scale the MachineDeployment

```bash
export KUBECONFIG=~/kubeone/kkp-admin-kubeconfig
kubectl -n kube-system scale md kkp-admin-pool1 --replicas 5
kubectl get nodes
```
