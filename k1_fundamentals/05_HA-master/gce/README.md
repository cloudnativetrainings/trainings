## Update KubeOne Cluster to HA setup

Since we want to match a productive setup as close as possible, in the next step we will setup a real HA cluster over 3 availability zones.

## Modify single master/node cluster to HA master setup

### Create and setup additional HA master nodes

The current `terraform.tfvars` file contains a value `control_plane_count = 1 ` and `control_plane_target_pool_members_count = 1`. This indicates that we only have one master instance set up and one listener to the load balancer for the control plane. Let's add the remaining master nodes to the cluster first. Change the value of the `control_plane_count` in `terraform.tfvars` to `3`: 
```hcl-terraform
cluster_name = "k1"

project = "stundent-xx-project-name"

region = "europe-west4"
# instance to create of the control plane
control_plane_count = 3 # <<<< CHANGE

# listeners of the Loadbalancer. Default is NOT HA, but ensure the bootstraping works -> after bootstraping increase to e.g. 3
control_plane_target_pool_members_count = 1
```
Save and execute the change:
```bash
### create the missing infrastructure
cd [training-repo]
cd ./src/gce/tf-infra
terraform apply
### install the missing master nodes
kubeone apply -t . --manifest ../kubeone.yaml --verbose
```
Now you should see 3 master nodes:
```bash
kubectl get nodes
NAME                           STATUS   ROLES    AGE     VERSION
k1-control-plane-1             Ready    master   32m     v1.19.9
k1-control-plane-2             Ready    master   4m12s   v1.19.9
k1-control-plane-3             Ready    master   3m10s   v1.19.9
k1-pool-az-a-ff4979f74-dnwzt   Ready    <none>   22m     v1.19.9
```

### Hint: Apply Changes of Cluster Properties by Using `kubeone apply`

The regular `kubone apply` command executes every change to the cluster like updates or installation additional nodes. Nevertheless there are potential changes you need to enforce and skip some preflight checks.

In case you want to change some of the cluster properties (e.g. enable a new feature), you can use the `--force-upgrade` command to reconcile the changes. Modify your manifest to include the desired changes, but don't change the Kubernetes version (unless you want to upgrade the cluster), and then run the `appĺy` command with the `--force-upgrade` flag:
```bash
kubeone apply --manifest kubeone.yaml -t tf.json --force-upgrade
```

Alternatively, the `kubeone upgrade` command can be used as well:

```bash
kubeone upgrade --manifest kubeone.yaml -t tf.json --force
```

The `--force` flag instructs KubeOne to ignore the preflight errors, including the error saying that you're trying to upgrade to the already running version. At the upgrade time, KubeOne ensures that the actual cluster configuration matches the expected configuration, and therefore the `upgrade` command can be used to modify cluster properties.


### Add Master nodes to Kubernetes API Load Balancer
  
If you now take a look at the loadbalancer, it still only shows `1` instance, https://console.cloud.google.com/net-services/loadbalancing/details/network/europe-west4/k1-control-plane. To fix this, we need to also update the target pool member count to `3`:
```hcl-terraform
cluster_name = "k1"

project = "stundent-xx-project-name"

region = "europe-west4"
# instance to create of the control plane
control_plane_count = 3

# listeners of the Loadbalancer. Default is NOT HA, but ensure the bootstraping works -> after bootstraping increase to e.g. 3
control_plane_target_pool_members_count = 3  # <<<< CHANGE
```
```bash
terraform apply
```
Now the LoadBalancer should have 3 `Backend` services. Check: [GCP Console > Network Service > Load Balancing](https://console.cloud.google.com/net-services/loadbalancing/loadBalancers/list)
  
### Verify cluster health

After everything is finished check the status of the kubernetes cluster that was created:

```bash
kubeone status -t . --manifest ../kubeone.yaml
```
```
INFO[23:48:18 CEST] Determine hostname…
INFO[23:48:19 CEST] Determine operating system…
INFO[23:48:20 CEST] Building Kubernetes clientset…
INFO[23:48:20 CEST] Verifying that Docker, Kubelet and Kubeadm are installed…
INFO[23:48:20 CEST] Verifying that nodes in the cluster match nodes defined in the manifest…
INFO[23:48:20 CEST] Verifying that all nodes in the cluster are ready…
INFO[23:48:20 CEST] Verifying that there is no upgrade in the progress…
NODE                 VERSION   APISERVER   ETCD
k1-control-plane-1   v1.19.9   healthy     healthy
k1-control-plane-2   v1.19.9   healthy     healthy
k1-control-plane-3   v1.19.9   healthy     healthy
```

By default the machine-controller deploys only one worker node:
```bash
kubectl get nodes
```
```
NAME                            STATUS   ROLES    AGE    VERSION
k1-control-plane-1              Ready    master   16m    v1.19.9
k1-control-plane-2              Ready    master   15m    v1.19.9
k1-control-plane-3              Ready    master   13m    v1.19.9
k1-pool-az-a-ff4979f74-dnwzt    Ready    <none>   14m    v1.19.9
```

The number of worker nodes can be controlled in a similar fashion like a Kubernetes deployment, in that the number of worker nodes are controlled by the "replicas" field. You can check the current status of the machine-deployment replicas with the following command:

```bash
kubectl -n kube-system get machinedeployment  

NAME           REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
k1-pool-az-a   1          1                    gce        ubuntu   1.19.9    10m
```

You can scale it up by using the normal kubectl scale command. The only difference in this scenario is that we are scaling up/down worker nodes instead of Pods.

```bash 
kubectl -n kube-system scale machinedeployment k1-pool-az-a --replicas=2
```
```bash
kubectl -n kube-system get machinedeployment
```
```
NAME           REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
k1-pool-az-a   2          1                    gce        ubuntu   1.19.9    43m
```
After a few minutes the healthy node should show up:
```bash
kubectl get nodes -l workerset=k1-pool-az-a -o wide
```
```
NAME                            STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP     OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
k1-pool-az-a-75cf6c85cf-4v7mw   Ready    <none>   3h6m    v1.19.9   10.240.0.11   34.91.118.218   Ubuntu 18.04.4 LTS   5.3.0-1029-gcp   docker://18.9.9
k1-pool-az-a-75cf6c85cf-j9dg4   Ready    <none>   3m25s   v1.19.9   10.240.0.12   34.90.218.24    Ubuntu 18.04.4 LTS   5.3.0-1029-gcp   docker://18.9.9
```
Currently, we don't need more than one node, so we scale down the workers back to 1:
```bash
kubectl -n kube-system scale machinedeployment k1-pool-az-a --replicas=1
```

The resource version can be grabbed using kubectl get -o yaml or kubectl describe.

Now check the node state and scale down by:
```bash
watch kubectl get md,ms,ma,node -A
```
Verify that the machine-controller also deleted the machines on GCE. For this you can check the [Compute Engine Instance](https://console.cloud.google.com/compute/instances) page.

![gce instances](../../.images/gce_k1_instances.png)
