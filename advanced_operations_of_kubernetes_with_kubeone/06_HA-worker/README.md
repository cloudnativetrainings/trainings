## Create HA Worker Pool

## Add additional Machine Pools for a multi AZ cluster

* To ensure that we have a real high-availability cluster we need at least one node in every availability zone. Therefore, we will create new pools by using the `machinedeployment` object. Currently, we only have one machine pool with one node in zone `europe-west4-a`:
  ```bash
  kubectl -n kube-system get machinedeployments
  ```

  ```text
  NAME           REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
  k1-pool-az-a   1          1                    gce        ubuntu   1.31.8    28m
  ```
  
  ```bash
  kubectl get nodes --label-columns failure-domain.beta.kubernetes.io/zone
  ```

  ```text
  NAME                            STATUS   ROLES           AGE     VERSION   ZONE
  k1-control-plane-1              Ready    control-plane   32m     v1.31.8   europe-west4-a
  k1-control-plane-2              Ready    control-plane   13m     v1.31.8   europe-west4-b
  k1-control-plane-3              Ready    control-plane   13m     v1.31.8   europe-west4-c
  k1-pool-az-a-7496775458-4kzlz   Ready    <none>          4m12s   v1.31.8   europe-west4-a
  ```   

* To reach an HA cluster, we would need worker nodes also in zones `europe-west4-b` and `europe-west4-c`. To accomplish this, we could reuse the current MachineDeployment `k1-pool-az-a` and duplicate the object for AZ `b` and `c`.
  1. Extract the current `machinedeployment` `k1-pool-az-a`:
     * Go the kube-system namespace
       ```bash
       kubectl config set-context --current --namespace=kube-system
       ```
     * Export current machine deployment
       ```bash
       cd $TRAINING_DIR/src/gce
       mkdir machines
       kubectl get machinedeployment k1-pool-az-a -o yaml | kexp > machines/md-zone-a.yaml
       ```
     * Take a look to the definition
       ```bash
       cat machines/md-zone-a.yaml
       ```


  2. Copy and replace the `machindeployment` definitions for zone `b` and `c`
     * Zone b
       ```bash
       cp machines/md-zone-a.yaml machines/md-zone-b.yaml
       sed -i 's/pool-az-a/pool-az-b/g' machines/md-zone-b.yaml
       sed -i 's/europe-west4-a/europe-west4-b/g' machines/md-zone-b.yaml
       ```
     * See the difference:
       ```bash
       diff machines/md-zone-a.yaml machines/md-zone-b.yaml
       ```
     * Zone c
       ```bash
       cp machines/md-zone-a.yaml machines/md-zone-c.yaml
       sed -i 's/pool-az-a/pool-az-c/g' machines/md-zone-c.yaml
       sed -i 's/europe-west4-a/europe-west4-c/g' machines/md-zone-c.yaml
       ```

  3. Apply the updated objects
     ```bash
     kubectl apply -f machines/
     ```
  
  4. Watch the update progress of the provisioning
     ```bash
     watch kubectl get machinedeployments,machine,nodes -A
     ```
     After a few minutes you should see, 3 nodes in total.
     ```text
     NAMESPACE     NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
     kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.31.8    68m
     kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.31.8    37m
     kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.31.8    37m
 
     NAMESPACE     NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS          AGE
     kube-system   machine.cluster.k8s.io/k1-pool-az-a-7496775458-4kzlz   gce        ubuntu   k1-pool-az-a-7496775458-4kzlz   1.31.8    34.32.128.54     45m
     kube-system   machine.cluster.k8s.io/k1-pool-az-b-5f9d8bcdbf-6kh29   gce        ubuntu   k1-pool-az-b-5f9d8bcdbf-6kh29   1.31.8    35.204.218.152   37m
     kube-system   machine.cluster.k8s.io/k1-pool-az-c-75c78c754d-6clwg   gce        ubuntu   k1-pool-az-c-75c78c754d-6clwg   1.31.8    34.90.127.118    37m
 
     NAMESPACE   NAME                                 STATUS   ROLES           AGE   VERSION
                 node/k1-control-plane-1              Ready    control-plane   72m   v1.31.8
                 node/k1-control-plane-2              Ready    control-plane   53m   v1.31.8
                 node/k1-control-plane-3              Ready    control-plane   52m   v1.31.8
                 node/k1-pool-az-a-7496775458-4kzlz   Ready    <none>          43m   v1.31.8
                 node/k1-pool-az-b-5f9d8bcdbf-6kh29   Ready    <none>          34m   v1.31.8
                 node/k1-pool-az-c-75c78c754d-6clwg   Ready    <none>          35m   v1.31.8
     ```
     
     Now check again the availability zones
     ```bash
     kubectl get nodes --label-columns failure-domain.beta.kubernetes.io/zone
     ```

     ```text
     NAME                            STATUS   ROLES           AGE   VERSION   ZONE
     k1-control-plane-1              Ready    control-plane   72m   v1.31.8   europe-west4-a
     k1-control-plane-2              Ready    control-plane   53m   v1.31.8   europe-west4-b
     k1-control-plane-3              Ready    control-plane   52m   v1.31.8   europe-west4-c
     k1-pool-az-a-7496775458-4kzlz   Ready    <none>          44m   v1.31.8   europe-west4-a
     k1-pool-az-b-5f9d8bcdbf-6kh29   Ready    <none>          35m   v1.31.8   europe-west4-b
     k1-pool-az-c-75c78c754d-6clwg   Ready    <none>          35m   v1.31.8   europe-west4-c
     ```

  5. Change back to the default namespace
     ```bash
     kubectl config set-context --current --namespace=default
     ```
     or
     ```bash
     kcns default
     ```

  6. Due to the dynamic management of the machine deployments, we could optionally remove the default `machinedeployment` config of the terraform `output.tf` file. In a disaster recovery situation, this would ensure that you will not mis-configure your machine configs. To do this, just remove everything of the `output "kubeone_workers"` section in the `output.tf` file:
     ```hcl-terraform
     ### remove everything of
     output "kubeone_workers" {
     #...
     }
     ```
     
     ```bash
     cd $TRAINING_DIR/src/gce/tf-infra
     vim output.tf
     terraform apply
     ```

<details>
<summary>Alternative Method</summary>

### (Alternative) HA by default in the Terraform output definition

Another option is to add the needed machine pools already in the beginning to the setup. To do this take a look into the `output.tf` and uncomment the complete section of `"${var.cluster_name}-pool-az-b"` and `"${var.cluster_name}-pool-az-c"`. If you would now create a new cluster, we would automatically get 3 `machinedeployments` for every zone.

```bash
terraform apply
kubeone apply -t . -m ../kubeone.yaml --verbose
```

> ***NOTE:*** The management of the worker nodes is way more flexible than that of the control plane nodes, so it's **NOT** recommended using the `output.tf` for the long term maintenance of the machine deployment objects. We recommend the usage of `md-XXX.yaml` files together with git to manage the cluster sizing. If no initial MachineDeployment should be created, remove all `"${var.cluster_name}-pool-az-X"` sections. 
</details>

Jump > [**Home**](../README.md) | Previous > [**HA Cluster Setup**](../05_HA-master/README.md) | Next > [**Application with External Access**](../07_deploy-app-02-external-access/README.md)