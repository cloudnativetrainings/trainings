# Create your first KubeOne cluster

Create a cluster `kubeone.yaml` file ([supported versions](https://docs.kubermatic.com/kubeone/master/architecture/compatibility/#supported-kubernetes-versions) should be at least one version behind of the latest, to be able to proceed with an upgrade later):

```yaml
# src/gce/kubeone.yaml

apiVersion: kubeone.k8c.io/v1beta2
kind: KubeOneCluster
name: k1
versions:
  kubernetes: '1.22.5'
cloudProvider:
  gce: {}
  cloudConfig: |-
    [global]
    regional = true
```

Start the KubeOne installation:

```bash
cd $TRAINING_DIR/src/gce
kubeone install -t ./tf-infra -m kubeone.yaml --verbose
```

KubeOne is combining the `kubeone.yaml` and Terraform state `./tf-infra/terraform.tfstate` files together. The initial infrastructure created by Terraform is used for the control plane. Afterwards KubeOne uses the Kubermatic machine-controller to manage the life-cycle of the worker nodes. The machine-controller requires several bits of information that must be provided by the user. Information that is needed is the following:

*zone, machineType, diskSize, network, subnetwork, sshPublicKeys, cloudProviderSpec*

As to not having to input these values manually to create the machine-controller spec (MachineDeployment ) for the cluster, KubeOne will merge the contents of the Terraform state (see `terraform output`) with the `kubeone.yaml` to provide:
- Cloud Controller Manager configuration `cloud-config`
- Full MachineDeployment yaml and apply it to the Kubernetes cluster automatically.

**Alternative:** You could also export the Terraform output into a tf.json file and use this one (not recommended, but makes the used content more visible):

```bash
cd $TRAINING_DIR/src/gce/tf-infra
terraform output -json > tf.json
cd ..
kubeone install --tfjson tf.json --verbose
```

To Adjust defaults for the upcoming Machine Deployment, take a look at the `output.tf` file. The rendered output of this file gets parsed by the `kubeone -t` command.

```bash
vim tf-infra/output.tf
```

You should get a similar output as shown below:

```text
INFO[23:07:06 CEST] Determine hostname…
INFO[23:07:06 CEST] Determine operating system…
INFO[23:07:07 CEST] Installing prerequisites…
INFO[23:07:07 CEST] Creating environment file…                    node=34.91.139.202 os=ubuntu
INFO[23:07:07 CEST] Configuring proxy…                            node=34.91.139.202 os=ubuntu
INFO[23:07:07 CEST] Installing kubeadm…                           node=34.91.139.202 os=ubuntu
INFO[23:07:12 CEST] Generating kubeadm config file…
INFO[23:07:12 CEST] Uploading config files…                       node=34.91.139.202
INFO[23:07:12 CEST] Configuring certs and etcd on first controller…
INFO[23:07:12 CEST] Ensuring Certificates…                        node=34.91.139.202
INFO[23:07:15 CEST] Downloading PKI…
INFO[23:07:15 CEST] Downloading PKI files…                        node=34.91.139.202
INFO[23:07:15 CEST] Creating local backup…                        node=34.91.139.202
INFO[23:07:15 CEST] Deploying PKI…
INFO[23:07:15 CEST] Configuring certs and etcd on consecutive controller…
INFO[23:07:15 CEST] Initializing Kubernetes on leader…
INFO[23:07:15 CEST] Running kubeadm…                              node=34.91.139.202
INFO[23:07:30 CEST] Building Kubernetes clientset…
INFO[23:07:31 CEST] Check if cluster needs any repairs…
INFO[23:07:31 CEST] Joining controlplane node…
INFO[23:07:31 CEST] Copying Kubeconfig to home directory…         node=34.91.139.202
INFO[23:07:31 CEST] Downloading kubeconfig…
INFO[23:07:31 CEST] Ensure node local DNS cache…
INFO[23:07:31 CEST] Activating additional features…
INFO[23:07:31 CEST] Applying canal CNI plugin…
INFO[23:07:35 CEST] Skipping applying addons because addons are not enabled…
INFO[23:07:35 CEST] Creating credentials secret…
INFO[23:07:35 CEST] Installing machine-controller…
INFO[23:07:36 CEST] Installing machine-controller webhooks…
INFO[23:07:36 CEST] Waiting for machine-controller to come up…
INFO[23:08:36 CEST] Creating worker machines…
```

A kubeconfig file will be generated after the KubeOne installation. Export it and use it to check the status of the Kubernetes cluster that was created:
>Replace the cluster_name as set in `terraform.tfvars`
```bash
export KUBECONFIG=$PWD/<cluster_name>-kubeconfig 
```

Check if you get one master and one worker node:

```bash
kubeone status -t ./tf-infra/
```

```text
INFO[23:48:18 CEST] Determine hostname…
INFO[23:48:19 CEST] Determine operating system…
INFO[23:48:20 CEST] Building Kubernetes clientset…
INFO[23:48:20 CEST] Verifying that Docker, Kubelet and Kubeadm are installed…
INFO[23:48:20 CEST] Verifying that nodes in the cluster match nodes defined in the manifest…
INFO[23:48:20 CEST] Verifying that all nodes in the cluster are ready…
INFO[23:48:20 CEST] Verifying that there is no upgrade in the progress…
NODE                 VERSION   APISERVER   ETCD
k1-control-plane-1   v1.22.5   healthy     healthy
```

```bash
kubectl get nodes
```

```text
NAME                           STATUS   ROLES                  AGE     VERSION
k1-control-plane-1             Ready    control-plane,master   13m     v1.22.5
```

Why is the worker node missing? -> Check the Machine Controller objects

```bash
kubectl -n kube-system get machinedeployment,machineset,machine
```

```text
NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
machinedeployment.cluster.k8s.io/k1-pool-az-a   1          0                    gce        ubuntu   1.22.5    1m19s

NAME                                               REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
machineset.cluster.k8s.io/k1-pool-az-a-ff4979f74   1          0                    gce        ubuntu   1.22.5    1m19s

NAME                                                  PROVIDER   OS       ADDRESS      KUBELET   AGE
machine.cluster.k8s.io/k1-pool-az-a-ff4979f74-4vg7c   gce        ubuntu   10.240.0.6   1.22.5    1m19s
```

The created `machine` object gives you more information

```bash
kubectl -n kube-system describe machine
```

```text
Versions:
  Kubelet:  1.22.5
Status:
Addresses:
  Address:  10.240.0.7
  Type:     InternalIP
Events:
Type    Reason         Age                From                Message
----    ------         ----               ----                -------
Normal  Created        24s                machine_controller  Successfully created instance
Normal  InstanceFound  24s (x2 over 24s)  machine_controller  Found instance at cloud provider, addresses: map[10.240.0.7:InternalIP]
```

The `Status` and `Events` fields show you that the machine is created, but not yet joined the cluster. Check after a few minutes again, and you will see:

```bash
kubectl -n kube-system describe machine
```

```text
Status:
Addresses:
  Address:  10.240.0.7
  Type:     InternalIP
Conditions:
  Last Heartbeat Time:   <nil>
  Last Transition Time:  <nil>
  Status:                True
  Type:                  Ready
Node Ref:
  API Version:       v1
  Kind:              Node
  Name:              k1-pool-az-a-ff4979f74-dnwzt
  Resource Version:  1884
  UID:               da325955-841f-4538-bfe0-6f46518cbcc8
Versions:
  Kubelet:  v1.22.5
Events:
Type    Reason                          Age                    From                Message
----    ------                          ----                   ----                -------
Normal  Created                         4m38s                  machine_controller  Successfully created instance
Normal  InstanceFound                   2m40s (x5 over 4m38s)  machine_controller  Found instance at cloud provider, addresses: map[10.240.0.7:InternalIP]
Normal  LabelsAnnotationsTaintsUpdated  2m20s (x2 over 2m20s)  machine_controller  Successfully updated labels/annotations/taints]
```

Now we should see, one master and one worker node with the corresponding machine objects:

```bash
kubectl -n kube-system get machinedeployment,machineset,machine,node
```

Check the Cloud Controller Manager credentials (used for provisioning worker nodes).

```bash
kubectl get secret -n kube-system cloud-provider-credentials -o jsonpath='{.data.GOOGLE_SERVICE_ACCOUNT}' | base64 -d | base64 -d
```

This Secret is created by KubeOne and used when creating MachineDeployment by `machine-controller`.

Jump > [**Home**](../README.md) | Previous > [**Cloud Infra Setup using Terraform**](../02_initial-cloud-infra-with-terraform/README.md) | Next > [**Deploy a Simple Application**](../04_deploy-app-01-simple/README.md)