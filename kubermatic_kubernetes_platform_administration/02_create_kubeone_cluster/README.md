# Create Master/Seed Kubernetes Cluster

```bash
cd ~/02_create_kubeone_cluster/
```

## Create infrastructure

```bash
make terraform

# Inspect the file ~/kubeone/tf.json

# verify
gcloud compute instances list
```

## Create Cluster

```bash
make create_cluster

# verify
export KUBECONFIG=~/kubeone/kkp-master-seed-cluster-kubeconfig
# TODO add this to the .trainingrc file
kubectl get nodes
```

## Scale the MachineDeployment

```bash
kubectl -n kube-system scale md kkp-master-seed-cluster-pool1 --replicas 3

# verify
gcloud compute instances list
kubectl get nodes
```
