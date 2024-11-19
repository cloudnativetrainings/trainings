# Create Master/Seed Kubernetes Cluster

In this lab you will create the Kubernetes Cluster in which we will deploy KKP.

```bash
cd ~/01_create_kubeone_cluster/
```

## Install KubeOne

```bash
make install_k1

# Verify installation
kubeone version
```

## Get KubeOne Configuration Files

```bash
make setup_k1_folder
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

# copy the kubeconfig to its location
mkdir ~/.kube
cp ~/kubeone/kkp-master-seed-cluster-kubeconfig ~/.kube/config

# verify
kubectl get nodes
```

## Scale the MachineDeployment

```bash
kubectl -n kube-system scale md kkp-master-seed-cluster-pool1 --replicas 3

# verify
kubectl -n kube-system get machinedeployment,machineset,machine
kubectl -n kube-system logs machine-controller-<HASH>
gcloud compute instances list
kubectl get nodes
```
