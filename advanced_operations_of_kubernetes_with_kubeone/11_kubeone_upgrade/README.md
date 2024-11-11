# KubeOne and Kubernetes Upgrade

KubeOne version and Kubernetes supported upgrade version, are quite in a close relationship as both follow a so called **Skew Policy**. To ensure that you get the latest fixes, run your latest KubeOne version for your target Kubernetes version, as a reference take a look to [KubeOne Docs > Architecture > Compatibility: Kubernetes](https://docs.kubermatic.com/kubeone/main/architecture/compatibility/supported-versions/).

As KubeOne will upgrade the Kubernetes cluster as a glance, it starts first by upgrading the control plane nodes (i.e. masters), Machine Controller, the MachineDeployments (optional: will update worker nodes) and at the last point with the features/addons.

KubeOne is doing a set of preflight checks to ensure all prerequisites are satisfied. The following checks are done by KubeOne:
 * `docker`, `kubelet` and `kubeadm` are installed,
 * information about nodes from the API matches what we have in the KubeOne configuration,
 * all nodes are healthy,
 * the [Kubernetes version skew policy](https://kubernetes.io/docs/setup/version-skew-policy/) is satisfied.

Once the upgrade process starts for a node, KubeOne applies the `kubeone.io/upgrade-in-progress` label on the node object. This label is used as a lock mechanism, so if the upgrade fails or it's already in progress, you can't start it again.

**NOTE:** For production environments, it's recommended to backup your cluster before running the upgrade process. You can do it by the [restic backup addon](https://docs.kubermatic.com/kubeone/main/examples/addons-backup), using [Velero](https://github.com/vmware-tanzu/velero) or any other tool of your choice.

Before running an upgrade, please ensure that your KubeOne version supports upgrading to the desired Kubernetes version. Check the [Kubernetes Versions Compatibility](https://docs.kubermatic.com/kubeone/main/architecture/compatibility/supported-versions/) part of the KubeOne's README for more details on supported Kubernetes versions for each KubeOne release. You can check what KubeOne version you're running using the `kubeone version` command.

**NOTE:** In Kubernetes it is recommended to only update one minor version every time. So if you want to update from `1.15.x` to `1.17.x`, please upgrade first to `1.16.x`! The latest release version can be found at [Github Kubernetes Releases](https://github.com/kubernetes/kubernetes/tags).

The upgrade process can be started by running the `kubeone apply` command or optionally if you want to also upgrade the worker nodes at the same time `kubeone apply --upgrade-machine-deployments`.
More Details will follow.

To start with the upgrade, please follow the below steps.

# KubeOne Cluster Upgrade Process

In this section, we are going to upgrade the KubeOne cluster from version `1.29.10` to latest `1.30.5`. However, if you check the [Supported Kubernetes Versions](https://docs.kubermatic.com/kubeone/v1.8/architecture/compatibility/supported-versions/#supported-kubernetes-versions), you will notice that KubeOne `1.8.0` does not support Kubernetes `1.30`.

Therefore, we need to start with changing our tooling container.

## Start New Tooling Container

We need version 1.8.3:

```bash
# exit the current tooling container, if you're already working on it:
exit

# start the tooling container
export KUBEONE_VERSION=1.8.3
docker run -d -it --network host -v $HOME/trainings/advanced_operations_of_kubernetes_with_kubeone:/home/kubermatic/training --name kubeone-tooling-${KUBEONE_VERSION} quay.io/kubermatic-labs/kubeone-tooling:${KUBEONE_VERSION}

# start a shell in the container
docker exec -it kubeone-tooling-${KUBEONE_VERSION} bash

# get the configuration
source ./training/.trainingrc
```

## Update Cluster Config

Update the `kubeone.yaml` file by changing the value of kubernetes to `1.30.5`:

```yaml
apiVersion: kubeone.k8c.io/v1beta2
kind: KubeOneCluster
name: k1
versions:
  kubernetes: '1.30.5'  # <<< UPDATE
cloudProvider:
#....
```

## Check access to cluster

Perform the check-list before proceeding:

1. Export the GCP authentication token with **`cat`**: 

```bash
echo $GOOGLE_CREDENTIALS
```
> Should output the credentials, if not continue with below step

If empty, see Setup chapter and execute
```bash
cd $TRAINING_DIR 
export GOOGLE_CREDENTIALS=$(cat ./.secrets/k8c-cluster-provisioner-sa-key.json)
```

2. SSH keys should be part of your key list (see also [How KubeOne uses SSH](https://docs.kubermatic.com/kubeone/main/guides/ssh/)):

```bash
ssh-add -l
```

```text
2048 SHA256:gAE3vgEERDISmtIwShe2CZtQZHam70sx4JznaLg3iEM kubermatic@7e54c85f5e39 (RSA)
```

If empty or your ssh-agent is not running, add your SSH identity file:
```bash
cd $TRAINING_DIR
eval `ssh-agent`
ssh-add .secrets/id_rsa
```

```text
Identity added: .secrets/id_rsa (kubermatic@7e54c85f5e39
```

3. For the upgrade to a newer Kubernetes version, it is recommended that you download the respective kubectl client that matches (at least) the upgraded kubernetes version (check before `kubectl version`):

```bash
kubectl version
```

```text
Client Version: v1.29.9
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.29.10
```

If the `Client Version` < your target kubernetes version, please update your `kubectl` to the latest version:

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
sudo mv kubectl /usr/bin/kubectl
sudo chmod +x /usr/bin/kubectl
```

>This step is recommended to be performed at local system because sometimes operational commands might give some errors, when you use a separate kubectl client version that is lower as the installed kubernetes cluster version.

>At the tooling container, you potentially need exec into as root, e.g.:`docker exec -it -u 0 kubeone-tool-container bash`

## Execute the upgrade through `kubeone apply`

As mentioned previously there are two ways to implement the upgrade:

### Option 1: Update Master + Worker in one action

The first approach to upgrade the cluster is to combine the upgrade of both the master and worker nodes together in a single command. KubeOne will first of all upgrade the master nodes then proceed to upgrade the worker nodes using the machine-controller (via the MachineDeployment) that is installed within the cluster. We are going to use this approach to upgrade the cluster in this write-up, below is the command syntax and sample output that should be printed out.

>Please ensure your latest terraform state is up to date.
```bash
cd $TRAINING_DIR/src/gce/tf-infra
terraform refresh
kubeone apply -t . -m ../kubeone.yaml --upgrade-machine-deployments --verbose
```

You can also check the full documentation for the upgrade process: [KubeOne Upgrade Process](https://docs.kubermatic.com/kubeone/main/tutorials/upgrading-clusters/)

#### Check/confirm status of the new upgrade version

After the upgrade process is finished check

```bash
kubectl version
```

```text
Client Version: v1.30.5-dispatcher
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.30.5
```

```bash
kubeone status -t . -m ../kubeone.yaml
```

```bash
# you need to wait until new machines are ready
kubectl get nodes,md -A
```

```text
NAME                                 STATUS                     ROLES           AGE   VERSION
node/k1-control-plane-1              Ready                      control-plane   97m   v1.30.5
node/k1-control-plane-2              Ready                      control-plane   89m   v1.30.5
node/k1-control-plane-3              Ready                      control-plane   88m   v1.30.5
node/k1-pool-az-a-54d9c6f5c-mfxjc    Ready,SchedulingDisabled   <none>          91m   v1.29.10
node/k1-pool-az-a-dcbd8b5d5-f6zbd    Ready                      <none>          33s   v1.30.5
node/k1-pool-az-b-69b79fbbb6-7xtvw   Ready,SchedulingDisabled   <none>          77m   v1.29.10
node/k1-pool-az-b-7fbcf7d6b8-vxwfh   Ready                      <none>          55s   v1.30.5
node/k1-pool-az-c-89f84f79-5mfjn     Ready                      <none>          50s   v1.30.5
node/k1-pool-az-c-c7d8c5dc9-glnbc    Ready,SchedulingDisabled   <none>          77m   v1.29.10

NAMESPACE     NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.30.5    94m
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.30.5    80m
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.30.5    80m
```

### Option 2: Upgrade first master nodes and then the workers

The second option would be to use KubeOne `kubeone apply` command only to upgrade only the master nodes and later the MachineDeployments or static workers.

>Please ensure your latest terraform state is up to date.
```bash
terraform refresh
kubeone apply -t . -m ../kubeone.yaml --verbose
```

If you take this route, then you will have to upgrade the worker nodes manually by editing all the MachineDeployment objects after upgrading the master nodes. Therefore, you need change the **`spec.template.spec.providerSpec.versions.kubelet`** section to `1.30.5`

```bash
vim ../machines/md-zone-a.yaml
```

Modify the yaml:

```yaml
    spec:
      metadata:
        creationTimestamp: null
        labels:
          workerset: k1-pool-az-a
      providerSpec:
        value:
          cloudProvider: gce
          cloudProviderSpec:
            assignPublicIPAddress: true
            diskSize: 20
            diskType: pd-ssd
            labels:
              k1-workers: pool-az-a
            machineType: n1-standard-1
            multizone: true
            network: https://www.googleapis.com/compute/v1/projects/test-01-int-05/global/networks/k1
            preemptible: true
            regional: false
            subnetwork: https://www.googleapis.com/compute/v1/projects/test-01-int-05/regions/europe-west4/subnetworks/k1-subnet
            tags:
            - firewall
            - targets
            - k1-pool-az-a
            zone: europe-west4-a
          operatingSystem: ubuntu
          operatingSystemSpec:
            distUpgradeOnBoot: false
          sshPublicKeys:
          - |
            ssh-rsa ...
      versions:
        kubelet: 1.29.10  << UPDATE to 1.30.5
```

Or use `sed`:

```bash
sed -i 's/1.29.10/1.30.5/g' ../machines/*.yaml
kubectl apply -f ../machines
```

When you save and exit the editor or applied the modified manifests, the machine-controller will detect the changes and proceed to update the worker nodes according to the new specification.
The upgrade uses a rolling-update style (just like the normal Kubernetes deployment controller) i.e. old worker nodes will not be deleted until the status of the newly provisioned node with the new Kubernetes version becomes ready, then it will proceed to upgrade the remaining worker nodes in a similar fashion (depending on the number of replicas) until all of them are upgraded to the desired Kubernetes version.

After a while check your updated cluster nodes:

```bash
kubectl get md,ms,ma,nodes -A
```

```text
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.30.5    92m
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.30.5    78m
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.30.5    78m

NAMESPACE     NAME                                                REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       MACHINEDEPLOYMENT   KUBELET   AGE
kube-system   machineset.cluster.k8s.io/k1-pool-az-a-54d9c6f5c    1          1                    gce        ubuntu   k1-pool-az-a        1.29.10   92m
kube-system   machineset.cluster.k8s.io/k1-pool-az-a-dcbd8b5d5    1                               gce        ubuntu   k1-pool-az-a        1.30.5    110s
kube-system   machineset.cluster.k8s.io/k1-pool-az-b-69b79fbbb6   1          1                    gce        ubuntu   k1-pool-az-b        1.29.10   78m
kube-system   machineset.cluster.k8s.io/k1-pool-az-b-7fbcf7d6b8   1                               gce        ubuntu   k1-pool-az-b        1.30.5    110s
kube-system   machineset.cluster.k8s.io/k1-pool-az-c-89f84f79     1                               gce        ubuntu   k1-pool-az-c        1.30.5    110s
kube-system   machineset.cluster.k8s.io/k1-pool-az-c-c7d8c5dc9    1          1                    gce        ubuntu   k1-pool-az-c        1.29.10   78m

NAMESPACE     NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS          AGE
kube-system   machine.cluster.k8s.io/k1-pool-az-a-54d9c6f5c-mfxjc    gce        ubuntu   k1-pool-az-a-54d9c6f5c-mfxjc    1.29.10   34.34.49.93      92m
kube-system   machine.cluster.k8s.io/k1-pool-az-a-dcbd8b5d5-f6zbd    gce        ubuntu                                   1.30.5    34.32.201.130    110s
kube-system   machine.cluster.k8s.io/k1-pool-az-b-69b79fbbb6-7xtvw   gce        ubuntu   k1-pool-az-b-69b79fbbb6-7xtvw   1.29.10   34.91.198.135    78m
kube-system   machine.cluster.k8s.io/k1-pool-az-b-7fbcf7d6b8-vxwfh   gce        ubuntu                                   1.30.5    34.90.189.9      110s
kube-system   machine.cluster.k8s.io/k1-pool-az-c-89f84f79-5mfjn     gce        ubuntu                                   1.30.5    34.91.101.160    110s
kube-system   machine.cluster.k8s.io/k1-pool-az-c-c7d8c5dc9-glnbc    gce        ubuntu   k1-pool-az-c-c7d8c5dc9-glnbc    1.29.10   35.204.113.253   78m

NAMESPACE   NAME                                 STATUS   ROLES           AGE   VERSION
            node/k1-control-plane-1              Ready    control-plane   96m   v1.30.5
            node/k1-control-plane-2              Ready    control-plane   87m   v1.30.5
            node/k1-control-plane-3              Ready    control-plane   87m   v1.30.5
            node/k1-pool-az-a-54d9c6f5c-mfxjc    Ready    <none>          90m   v1.29.10
            node/k1-pool-az-b-69b79fbbb6-7xtvw   Ready    <none>          76m   v1.29.10
            node/k1-pool-az-c-c7d8c5dc9-glnbc    Ready    <none>          76m   v1.29.10
```

After a few more minutes, the worker nodes also will be there in a new version. 

If you have e.g. a machine deployment with a higher replica count, you potentially can speed up the upgrade by setting a higher count of `maxSurge`:

```
spec:
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
```

The property `maxUnavailable: 0` ensures, that every time during the update the capacity of the cluster will be stable. Anyway nodes get rescheduled by draining, what could influence your application. To ensure rolling update of Nodes don't have an impact to your workload, check if your application:
- Is managed by a higher object controller like `Deployment`
- Replica count is higher as `1`. If only `1` replica is there, a short downtime during rescheduling is for sure present
- Clients talking through a service to your set of pods
- Host Anti-Affinity - Pods of get placed on different hosts or availability zones
- Higher ensures could be achieved by [Quality Classes](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/) and/or [Pod disruption budgets](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets)

### OS Upgrades

At Ubuntu, it's recommended to set the flag `distUpgradeOnBoot: true` in the `MachineDeployment:

```yaml
apiVersion: cluster.k8s.io/v1alpha1
kind: MachineDeployment
#...
spec: 
  template:
    spec:
      providerSpec:
        value:
          operatingSystem: ubuntu
          operatingSystemSpec:
            distUpgradeOnBoot: true
```

This ensures that during the bootstrapping of new nodes, all needed OS updated get installed.

For Flatcar Linux, KubeOne installs automatically the Flatcar OS update operator [kinvolk/flatcar-linux-update-operator](https://github.com/kinvolk/flatcar-linux-update-operator) what manage the upgrades if your spec is:

```yaml
apiVersion: cluster.k8s.io/v1alpha1
kind: MachineDeployment
#...
spec: 
  template:
    spec:
      providerSpec:
        value:
          operatingSystem: flatcar
          operatingSystemSpec:
            disableAutoUpdate: false
```

Jump > [**Home**](../README.md) | Previous > [**KubeOne AddOns**](../10_addons-sc-and-restic-etcd-backup/README.md) | Next > [**Cluster AutoScaling**](../12_cluster-autoscaling/README.md)