# KubeOne Cluster cleanup

To cleanup your cloud resource, KubeOne tool will support you.

## KubeOne reset

In the first step, KubeOne will remove the worker nodes and reset the control plane nodes to the state before you installed Kubernetes. The command is also helpful if during the installation something breaks, and you don't want to re-provision all machines:

```bash
cd $TRAINING_DIR/src/gce
kubeone reset -t ./tf-infra
```

## Destroy Terraform Infrastructure

As a last step, you should destroy your Terraform infrastructure. The next command will delete:
- The master machines
- The networking
- The Kubernetes API Load Balancer

```bash
cd $TRAINING_DIR/src/gce/tf-infra
terraform destroy
```

If the following Terraform error occurs:

```text
Error: Error waiting for Deleting Network: The network resource 'projects/student-00/global/networks/k1' is already being use
d by 'projects/student-00/global/routes/k1-127d2a55-58f2-4955-8666-3aaa030902b
```
Delete the leftover routes manually (Terraform doesn't clean them up in a proper way and CCM doesn't delete the routes either).

```bash
gcloud compute routes list
gcloud compute routes delete k1-127d2a55-58f2-4955-8666-3aaa030902b4
```

## Alternative: Cluster pause

Alternatively you can store the state of your cluster for later usage. For this you can go to the [GCP - Compute Engine - VM Instances](https://console.cloud.google.com/compute/instances) page and **pause** all machines. 

After you **unpause** all machines, the machine controller will start again and detect the machines.

**HINT:** You can also scale down the worker nodes **before** to `0` like it's described in [08_optimize-workers/README.md](../08_optimize-workers/README.md). After the machines are gone, **pause** only the master nodes. This will ensure that your etcd state is still secured, and the stateless worker node config is stored.

```bash
kubectl scale md -n kube-system --replicas=0 --all
#.... wait until the machines are deleted -> then pause master
```

After the masters are **unpaused**, scale up again:

```bash
kubectl scale md -n kube-system --replicas=1 --all
```

Jump > [**Home**](../README.md) | Previous > [**Bonus**](../90_bonus/README.md)