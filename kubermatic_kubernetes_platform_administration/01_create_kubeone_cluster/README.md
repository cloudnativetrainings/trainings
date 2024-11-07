# Create Master/Seed Kubernetes Cluster

```bash
cd ~/02_create_kubeone_cluster/
```

# Prepare KubeOne and KKP installation

### Install KubeOne

```bash
make install_k1

# Verify installation
kubeone version
```

### Get KubeOne Configuration Files

```bash
make setup_k1_folder
```

## Create infrastructure



eval `ssh-agent`
ssh-add ~/secrets/kkp_admin_training
https://docs.kubermatic.com/kubeone/v1.8/guides/ssh/




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
cp ~/kubeone/kkp-master-seed-cluster-kubeconfig ~/.kube/config
# export KUBECONFIG=~/kubeone/kkp-master-seed-cluster-kubeconfig
# TODO use later for merging kubeconfigs: https://hbayraktar.medium.com/merging-multiple-kubeconfig-files-into-one-a-comprehensive-guide-33cb7990edfc
# TODO add this to the .trainingrc file
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
