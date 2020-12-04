# Setup environment

## Create the cluster

1. Visit the kubermatic training environment in your browser
1. Choose the project `training`
1. Click the button `Add Cluster`
1. Choose the Provider `Google Cloud` and the Datacenter `Frankfurt`
1. Fill in the cluster details
    1. Name the cluster, eg `student-00`
    1. Choose Kubernetes in version `1.17.13`
    1. Clicke the button `Next`
1. Fill in the cluster settings
    1. Choose the Provider Preset `kubermatic`
    1. Clicke the button `Next`
1. Customize the Initial Nodes
    1. Name the machineset, eg `student-00`
    1. Set the replicas to 2
    1. Choose the OS `Ubuntu`
    1. Choose the Disk Size 100 GB
    1. Set the zone to `europe-west3-a`
    1. Choose the disk type `pd-standard`
    1. Choose the machine type `n1-standard-4`
    1. Clicke the button `Next`
1. Revisit your settings and click the button `Create`
1. After the cluster got created download the kubeconfig via the button showing an arrow on the right above.

## Connect to the cluster

1. Visit the [Google Cloud Shell](https://shell.cloud.google.com/)
1. Login with your training account
1. Drag and Drop your kubeconfig into the Google Cloud Shell
1. Connect to your cluster via
```bash
export KUBECONFIG=kubeconfig-admin-<YOUR-CLUSTER_ID>
```
1. Verify everything
```bash
kubectl get nodes
```

## Add kubectl bash completion

```bash
. <(kubectl completion bash)
```