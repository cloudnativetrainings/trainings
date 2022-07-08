# Create Master/Seed Kubernetes Cluster

```bash
cd ~/02_create_kubeone_cluster/
```

## Create infrastructure

```bash
make terraform

# Inspect the file tf.json
```

## Create Cluster

```bash
make create_cluster
```

## Scale the MachineDeployment

```bash
export KUBECONFIG=~/kubeone/kkp-admin-kubeconfig
kubectl -n kube-system scale md kkp-admin-pool1 --replicas 5
kubectl get nodes
```

Jump > [Home](../README.md) | Previous > [Prepare Installation](../01_prepare/README.md) | Next > [Setup KKP Master](../03_setup_kkp_master/README.md)
