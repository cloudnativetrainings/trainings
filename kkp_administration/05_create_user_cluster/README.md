# Create User Clusters

## Create Cluster within UI

Generate a ServiceAccount holding the GCE Credentials via

```bash
base64 -w0 ~/secrets/key.json
```

* Create a new project
* Click Create Cluster
* Within Tab `Provider`
    * Choose Provider `Google Cloud`
    * Choose Datecenter `Frankurt`
* Within Tab `Cluster`
    * Generate a random Cluster name
* Within Tab `Settings`
    * Copy the base64 encoded GCE key.json
* Within Tab `Initial Nodes`
    * Generate a random MachineDeployment name
    * Set the number of replicas to 3
    * Choose Disk Type `pd-ssd`
    * Choose Machine Type `n1-standard-2`

### Verify in Terminal

You will find a new namespace holding all the control plane components of the user cluster

```bash
kubectl get ns

# See all the control plane components of the cluster
kubectl -n cluster-XXXXX get pods 

# Delete one of the etcd nodes
kubectl -n cluster-XXXXX delete pod etcd-0

# The StatefulSet will take care to restart the deleted etcd-0 node
kubectl -n cluster-XXXXX get pods 

# Show the cluster CRD
kubectl get cluster XXXXX -o yaml
```

### Connect to the User Cluster

Download the kubeconfig via the following button:

![](../img/get_kubeconfig.png)

Drag&Drop the downloaded kubeconfig into the Google Cloud Shell.

Create a new Terminal:

![](../img/choose_project.png)

Connect to the User Cluster

```bash
export KUBECONFIG=~/kubeconfig-admin-XXXXX

kubectl get nodes
```

## Create Provider Presets & Cluster Templates

### Create a Provider Preset

Open the Admin Panel like this:

![](../img/admin_panel.png)

Choose Provider Presets

Create a Preset
1. On the Preset Tab choose a name, eg `gce`
1. On the Provider Tab choose Google Cloud
1. In the Settings Tab add the base64 encoded GCE key.json (you can get it again via `base64 ~/secrets/key.json -w0`)

### Create Cluster Template

See the steps of the section `Create Cluster within UI` on how to create a ClusterTemplate. Make sure to make use of the Provider Preset of the previous step.

<!-- TODO add kubectl commands for getting ProviderPreset and ClusterTemplate -->

### Create Cluster using the Provider Preset and the Cluster Template

Within the UI create a cluster via the button `Create Cluster from Template` and make use of the template created in the previous step.

Jump > [Home](../README.md) | Previous > [Setup KKP Seed](../04_setup_kkp_seed/README.md) | Next > [Upgrade User Cluster](../06_upgrade_user_cluster/README.md)
