## Create HA Worker Pool

## Add additional Machine Pools for a multi AZ cluster

* To ensure that we have a real high-availability cluster we need at least one node in every availability zone. Therefore, we will create new pools by using the `machinedeployment` object. Currently, we only have one machine pool with one node in zone `europe-west4-a`:
  ```bash
  kubectl -n kube-system get machinedeployments
  ```

  ```text
  NAME           REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
  k1-pool-az-a   1          1                    gce        ubuntu   1.22.5    34m
  ```
  
  ```bash
  kubectl get nodes --label-columns failure-domain.beta.kubernetes.io/zone
  ```

  ```text
  NAME                            STATUS                        ROLES    AGE     VERSION   ZONE
  k1-control-plane-1              Ready                         master   117m    v1.22.5   europe-west4-a
  k1-control-plane-2              Ready                         master   41m     v1.22.5   europe-west4-b
  k1-control-plane-3              Ready                         master   40m     v1.22.5   europe-west4-c
  k1-pool-az-a-84dff9464c-g59bv   Ready                         <none>   2m30s   v1.22.5   europe-west4-a
  ```   

* To reach an HA cluster, we would need worker nodes also in zones `europe-west4-b` and `europe-west4-c`. To accomplish this, we could reuse the current MachineDeployment `k1-pool-az-a` and duplicate the object for AZ `b` and `c`.
  1. Extract the current `machinedeployment` `k1-pool-az-a`:
     * Go the kube-system namespace
       ```bash
       kubectl config set-context --current --namespace=kube-system
       ```
       or
       ```bash
       kcns kube-system
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
     kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.22.5    3h33m
     kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.22.5    3m30s
     kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.22.5    3m30s

     NAMESPACE     NAME                                                   PROVIDER   OS       ADDRESS       KUBELET   AGE
     kube-system   machine.cluster.k8s.io/k1-pool-az-a-75cddb6cd9-slgqk   gce        ubuntu   10.240.0.13   1.22.5    3m30s
     kube-system   machine.cluster.k8s.io/k1-pool-az-b-777d7cc84b-g76zf   gce        ubuntu   10.240.0.15   1.22.5    3m29s
     kube-system   machine.cluster.k8s.io/k1-pool-az-c-5d5cfcc5bf-gpjpg   gce        ubuntu   10.240.0.14   1.22.5    3m29s

     NAMESPACE   NAME                                         STATUS   ROLES    AGE     VERSION
                 node/k1-control-plane-1                       Ready    master   4h11m   v1.22.5
                 node/k1-control-plane-2                       Ready    master   3h34m   v1.22.5
                 node/k1-control-plane-3                       Ready    master   3h33m   v1.22.5
                 node/k1-pool-az-a-75cddb6cd9-slgqk            Ready    <none>   81s     v1.22.5
                 node/k1-pool-az-b-777d7cc84b-g76zf            Ready    <none>   77s     v1.22.5
                 node/k1-pool-az-c-5d5cfcc5bf-gpjpg            Ready    <none>   67s     v1.22.5
     ```
     
     Now check again the availability zones
     ```bash
     kubectl get nodes --label-columns failure-domain.beta.kubernetes.io/zone
     ```
     ```text
     NAME                            STATUS   ROLES    AGE     VERSION   ZONE
     k1-control-plane-1              Ready    master   4h11m   v1.22.5   europe-west4-a
     k1-control-plane-2              Ready    master   3h35m   v1.22.5   europe-west4-b
     k1-control-plane-3              Ready    master   3h34m   v1.22.5   europe-west4-c
     k1-pool-az-a-75cddb6cd9-slgqk   Ready    <none>   99s     v1.22.5   europe-west4-a
     k1-pool-az-b-777d7cc84b-g76zf   Ready    <none>   95s     v1.22.5   europe-west4-b
     k1-pool-az-c-5d5cfcc5bf-gpjpg   Ready    <none>   85s     v1.22.5   europe-west4-c
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

### (Alternative) HA by default in the Terraform output definition

Another option is to add the needed machine pools already in the beginning to the setup. To do this take a look into the `output.tf` and uncomment the complete section of `"${var.cluster_name}-pool-az-b"` and `"${var.cluster_name}-pool-az-c"`. If you would now create a new cluster, we would automatically get 3 `machinedeployments` for every zone.

```bash                                         
terraform apply
kubeone apply -t . -m ../kubeone.yaml --verbose
```

> ***NOTE:*** The management of the worker nodes is way more flexible than that of the control plane nodes, so it's **NOT** recommended using the `output.tf` for the long term maintenance of the machine deployment objects. We recommend the usage of `md-XXX.yaml` files together with git to manage the cluster sizing. If no initial MachineDeployment should be created, remove all `"${var.cluster_name}-pool-az-X"` sections. 

Jump > [**Home**](../README.md) | Previous > [**HA Cluster Setup**](../05_HA-master/README.md) | Next > [**Application with External Access**](../07_deploy-app-02-external-access/README.md)