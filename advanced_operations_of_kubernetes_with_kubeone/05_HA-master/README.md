## Update KubeOne Cluster to HA setup

In the next step, we will setup a real HA cluster over 3 availability zones to match a production setup as close as possible. 

## Modify single master/node cluster to HA master setup

### Create and setup additional HA master nodes

* The current `terraform.tfvars` file contains a value `control_plane_vm_count = 1 ` and `control_plane_target_pool_members_count = 1`. This indicates that we only have one master instance set up and one listener to the load balancer for the control plane. Let's add the remaining master nodes to the cluster first. Change the value of the `control_plane_vm_count` in `terraform.tfvars` to `3` and save: 
  ```hcl-terraform
  cluster_name = "k1"
  
  project = "stundent-xx-project-name"
  
  region = "europe-west4"
  # instance to create of the control plane
  control_plane_vm_count = 3 # <<<< CHANGE
  
  # listeners of the Loadbalancer. Default is NOT HA, but ensure the bootstraping works -> after bootstraping increase to e.g. 3
  control_plane_target_pool_members_count = 1
  ```

* Apply to create the missing infrastructure
  ```bash
  cd $TRAINING_DIR/src/gce/tf-infra
  terraform apply
  ```

* Install the missing master nodes with KubeOne
  ```bash
  kubeone apply -t . --manifest ../kubeone.yaml --verbose
  ```

* Now you should see 3 master nodes:
  ```bash
  kubectl get nodes
  ```
  Output:
  ```text
  NAME                            STATUS   ROLES           AGE     VERSION
  k1-control-plane-1              Ready    control-plane   23m     v1.31.8
  k1-control-plane-2              Ready    control-plane   4m4s    v1.31.8
  k1-control-plane-3              Ready    control-plane   3m21s   v1.31.8
  k1-pool-az-a-7496775458-v92w2   Ready    <none>          17m     v1.31.8
  ```

<details>
<summary>More info about "kubeone apply"</summary>
* The regular `kubone apply` command executes every change to the cluster like updates or installation additional nodes. Nevertheless, there are potential changes you need to enforce and skip some preflight checks.

  In case, you want to change some of the cluster properties (e.g. enable a new feature), you can use the `--force-upgrade` command to reconcile the changes. Modify your manifest to include the desired changes, but don't change the Kubernetes version (unless you want to upgrade the cluster), and then run the `appĺy` command with the `--force-upgrade` flag:

  ```bash
  kubeone apply -t . --manifest ../kubeone.yaml --force-upgrade
  ```
  or 
  ```bash
  kubeone apply -t tf.json --manifest ../kubeone.yaml --force-upgrade
  ```

  >The `--force` flag instructs KubeOne to ignore the preflight errors, including the error saying that you're trying to upgrade to the already running version. At the upgrade time, KubeOne ensures that the actual cluster configuration matches the expected configuration.
</details>

### Add Master nodes to Kubernetes API Load Balancer
  
* If you now take a look at the LoadBalancer, it still only shows `1` instance, https://console.cloud.google.com/net-services/loadbalancing/details/network/europe-west4/k1-control-plane. To fix this, we need to also update the target pool member count to `3`:
  ```hcl-terraform
  cluster_name = "k1"
  
  project = "stundent-xx-project-name"
  
  region = "europe-west4"
  # instance to create of the control plane
  control_plane_vm_count = 3
  
  # listeners of the LoadBalancer. Default is NOT HA, but ensure the bootstrapping works -> after bootstrapping increase to e.g. 3
  control_plane_target_pool_members_count = 3  # <<<< CHANGE
  ```

* Apply to update the Load Balancer backend listener pool.
  ```bash
  terraform apply
  ```
  >Now the LoadBalancer should have 3 `Backend` services. Check: [GCP Console > Network Service > Load Balancing](https://console.cloud.google.com/net-services/loadbalancing/loadBalancers/list)
  
### Verify cluster health

* After everything is finished check the status of the kubernetes cluster that was created:
  ```bash
  kubeone status -t . --manifest ../kubeone.yaml
  ```
  
  ```text
  INFO[08:53:01 UTC] Determine hostname...
  INFO[08:53:01 UTC] Determine operating system...
  INFO[08:53:02 UTC] Building Kubernetes clientset...
  INFO[08:53:02 UTC] Verifying that nodes in the cluster match nodes defined in the manifest...
  INFO[08:53:02 UTC] Verifying that all nodes in the cluster are ready...
  INFO[08:53:02 UTC] Verifying that there is no upgrade in progress...
  NODE                 VERSION   APISERVER   ETCD
  k1-control-plane-1   v1.31.8   healthy     healthy
  k1-control-plane-3   v1.31.8   healthy     healthy
  k1-control-plane-2   v1.31.8   healthy     healthy
  ```

* By default, the machine-controller deploys only one worker node. The number of worker nodes can be controlled in a similar fashion like a Kubernetes deployment, in that the number of worker nodes are controlled by the `replicas` field. You can check the current status of the machine-deployment replicas with the following command:
  
  ```bash
  kubectl -n kube-system get machinedeployment
  ```
  ```text
  NAME           REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
  k1-pool-az-a   1          1                    gce        ubuntu   1.31.8    22m
  ```

* You can scale it up by using the normal kubectl scale command. The only difference in this scenario is that we are scaling up/down worker nodes instead of Pods.
  ```bash
  kubectl -n kube-system scale machinedeployment k1-pool-az-a --replicas=2
  ```
  
  ```bash
  kubectl -n kube-system get machinedeployment
  ```

  ```text
  NAME           REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
  k1-pool-az-a   2          1                    gce        ubuntu   1.31.8    23m
  ```

* After a few minutes the healthy node should show up:
  ```bash
  kubectl get nodes -l workerset=k1-pool-az-a -o wide
  ```

  ```text
  NAME                            STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP     OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
  k1-pool-az-a-7496775458-4kzlz   Ready    <none>   42s   v1.31.8   10.164.0.7    34.32.128.54    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
  k1-pool-az-a-7496775458-v92w2   Ready    <none>   23m   v1.31.8   10.164.0.4    34.90.127.118   Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
  ```

* Currently, we don't need more than one node, so we scale down the workers back to 1:
  ```bash
  kubectl -n kube-system scale machinedeployment k1-pool-az-a --replicas=1
  ```

* Now check the node state and scale down by:
  ```bash
  watch kubectl get md,ms,ma,node -A
  ```

* Verify that the machine-controller also deleted the machines on GCE. For this you can check the [Compute Engine Instance](https://console.cloud.google.com/compute/instances) page.
  ![gce instances](../.images/gce_k1_instances.png)


Jump > [**Home**](../README.md) | Previous > [**Deploy a Simple Application**](../04_deploy-app-01-simple/README.md) | Next > [**HA Worker Pool**](../06_HA-worker/README.md)