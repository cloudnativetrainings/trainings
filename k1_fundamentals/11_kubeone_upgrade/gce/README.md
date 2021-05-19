# KubeOne and Kubernetes Upgrade

KubeOne Version and Kubernetes supported upgrade version, are quite in a close relationship as both follow a so called **Skew Policy**. To ensure that you get the latest fixes, run your latest kubeone version for your target Kubernetes version, as a reference take a look to [KubeOne Docs > Architecture > Compatibility: Supported Kubernetes Versions](https://docs.kubermatic.com/kubeone/master/architecture/compatibility/).

As KubeOne will upgrade the Kubernetes cluster as a glance, it starts first by upgrading the control plane nodes (i.e. masters),Machine Controller, the MachineDeployments  (optional: will update worker nodes) and at the last point with the features/addons.

KubeOne is doing a set of preflight checks to ensure all prerequisites are satisfied. The following checks are done by KubeOne:

* Docker, Kubelet and Kubeadm are installed,
* information about nodes from the API matches what we have in the KubeOne configuration,
* all nodes are healthy,
* the [Kubernetes version skew policy](https://kubernetes.io/docs/setup/version-skew-policy/) is satisfied.

Once the upgrade process starts for a node, KubeOne applies the `kubeone.io/upgrade-in-progress` label on the node object. This label is used as a lock mechanism, so if the upgrade fails or it's already in progress, you can't start it again.

**NOTE:** For productive systems it's recommended to backup your cluster before running the upgrade process. You can do it by the [restic backup addon](https://docs.kubermatic.com/kubeone/master/examples/addons_backup), using [Velero](https://github.com/vmware-tanzu/velero) or any other tool of your choice.

Before running an upgrade please ensure that your KubeOne version supports upgrading to the desired Kubernetes version. Check the [Kubernetes Versions Compatibility](https://docs.kubermatic.com/kubeone/master/architecture/compatibility/) part of the KubeOne's README for more details on supported Kubernetes versions for each KubeOne release. You can check what KubeOne version you're running using the `kubeone version` command.

**NOTE:** In Kubernetes it is recommended to only update one minor version every time. So if you want to update from `1.15.x` to `1.17.x`, please upgrade first to `1.16.x`! The latest release version can be found at [Github Kubernetes Releases](https://github.com/kubernetes/kubernetes/tags).

The upgrade process can be started by running the ```kubeone apply``` command or optionally if you want to also upgrade the worker nodes at the same time ```kubeone apply --upgrade-machine-deployments```. More Details will follow.

To start with the upgrade please follow the steps below:

# KubeOne Cluster Upgrade Process

In this section, we are going to upgrade the KubeOne cluster from version `1.19.9` to latest `1.20.7`

## Update Cluster Config
Update the `kubeone.yaml` file by changing the value of kubernetes to `1.20.7`:

```yaml
apiVersion: kubeone.io/v1beta1
kind: KubeOneCluster
name: k1
versions:
  kubernetes: '1.20.7' <<< UPDATE
cloudProvider:
#....
```

## Check access to cluster

Perform the check-list before proceeding:

1. Export the GCP authentication token with **`cat`**: 
```bash
echo echo $GOOGLE_CREDENTIALS 
{ "type": "service_account", "project_id": "YOUR PROJECT", "private_key_id": "..." }

# if empty see 00_setup chapter and execute
export GOOGLE_CREDENTIALS=$(cat path/to/your_service_account.json)
```

2. SSH keys should be part of your key list (see also [How KubeOne uses SSH](https://github.com/kubermatic/kubeone/blob/master/docs/ssh.md)):
```bash
ssh-add -l
```
```
2048 SHA256:gAE3vgEERDISmtIwShe2CZtQZHam70sx4JznaLg3iEM kubermatic@7e54c85f5e39 (RSA)
```
*Hint: If empty or your ssh-agent is not running, add your SSH identity file:*
```bash
cd [training-repo]
eval `ssh-agent`
ssh-add .secrets/id_rsa
```
```
Identity added: .secrets/id_rsa (kubermatic@7e54c85f5e39
```

3. For the upgrade to a newer Kubernetes version, it is recommended that you download the respective kubectl client that matches (at least) the upgraded kubernetes version (check before `kubectl version`):
```bash
kubectl version --short
```
```
Client Version: v1.21.1
Server Version: v1.19.9
```
If the `Client Version`is LOWER then your target version, please update your `kubectl` to the latest version:
```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
sudo mv kubectl /usr/bin/kubectl
sudo chmod +x /usr/bin/kubectl
```
*N.B - This step is recommended at local system because sometimes operational commands might give some errors when you use a separate kubectl client version that is lower as the installed kubernetes cluster version. 

*At the tooling container you potentially need exec into as root, e.g.:`docker exec -it -u 0 kubeone-tool-container bash`*

## Execute the upgrade through `kubeone apply`

As mentioned previously there are two ways to implement the upgrade:
To watch the upgrade process, open a **SECOND shell**:
```
### if you use the tooling conainer, open a new shell, do again
docker exec -it kubeone-tool-container bash

cd [training-repo]
export KUBECONFIG=`pwd`/src/gce/k1-kubeconfig
watch kubectl get md,ms,ma,nodes -A
```
### 1. Option: Update Master + Worker in one action

The first approach to upgrade the cluster is to combine the upgrade of both the master and worker nodes together in a single command. KubeOne will first of all upgrade the master nodes then proceed to upgrade the worker nodes using the machine-controller (via the MachineDeployment) that is installed within the cluster. This is the approach we are going to use to upgrade the cluster in this write-up, below is the command syntax and sample output that should be printed out.

***Please ensure your terraform state is up to date***.

```bash
# ensure latest terraform information are loaded
cd src/gce/tf-infra
terraform refresh

kubeone apply -t . -m ../kubeone.yaml --upgrade-machine-deployments --verbose
```
```
INFO[15:50:30 CEST] Building Kubernetes clientset…
INFO[15:50:32 CEST] Determine hostname…
INFO[15:50:34 CEST] Determine operating system…
INFO[15:50:34 CEST] Checking are all prerequisites installed…     node=34.77.255.50
INFO[15:50:34 CEST] Checking are all prerequisites installed…     node=35.241.157.248
INFO[15:50:34 CEST] Checking are all prerequisites installed…     node=34.77.67.173
INFO[15:50:34 CEST] Running preflight checks…
INFO[15:50:34 CEST] Verifying are all nodes running…
INFO[15:50:34 CEST] Verifying are correct labels set on nodes…
INFO[15:50:34 CEST] Verifying do all node IP addresses match with our state…
INFO[15:50:34 CEST] Verifying is it possible to upgrade to the desired version…
INFO[15:50:34 CEST] Labeling leader control plane…                node=35.241.157.248
INFO[15:50:34 CEST] Upgrading Kubernetes binaries on leader control plane…  node=35.241.157.248
INFO[15:50:54 CEST] Waiting 1m0s seconds to ensure kubelet is up…  node=35.241.157.248
INFO[15:51:54 CEST] Generating kubeadm config …                   node=35.241.157.248
INFO[15:51:54 CEST] Uploading kubeadm config to leader control plane node…  node=35.241.157.248
INFO[15:51:54 CEST] Running 'kubeadm upgrade' on leader control plane node…  node=35.241.157.248
INFO[15:52:46 CEST] Waiting 15s seconds to ensure all components are up…  node=35.241.157.248
INFO[15:53:01 CEST] Unlabeling leader control plane…              node=35.241.157.248
INFO[15:53:02 CEST] Labeling follower control plane…              node=34.77.67.173
INFO[15:53:02 CEST] Upgrading Kubernetes binaries on follower control plane…  node=34.77.67.173
INFO[15:53:21 CEST] Waiting 1m0s seconds to ensure kubelet is up…  node=34.77.67.173
INFO[15:54:21 CEST] Running 'kubeadm upgrade' on the follower control plane node…  node=34.77.67.173
INFO[15:54:42 CEST] Waiting 15s seconds to ensure all components are up…  node=34.77.67.173
INFO[15:54:57 CEST] Unlabeling follower control plane…            node=34.77.67.173
INFO[15:54:58 CEST] Labeling follower control plane…              node=34.77.255.50
INFO[15:54:58 CEST] Upgrading Kubernetes binaries on follower control plane…  node=34.77.255.50
INFO[15:55:17 CEST] Waiting 1m0s seconds to ensure kubelet is up…  node=34.77.255.50
INFO[15:56:17 CEST] Running 'kubeadm upgrade' on the follower control plane node…  node=34.77.255.50
INFO[15:56:27 CEST] Waiting 15s seconds to ensure all components are up…  node=34.77.255.50
INFO[15:56:42 CEST] Unlabeling follower control plane…            node=34.77.255.50
INFO[15:56:42 CEST] Downloading PKI files…                        node=35.241.157.248
INFO[15:56:43 CEST] Creating credentials secret…
INFO[15:56:43 CEST] Installing machine-controller…
INFO[15:56:45 CEST] Installing machine-controller webhooks…
INFO[15:56:46 CEST] Waiting for machine-controller to come up…
INFO[15:57:06 CEST] Upgrade MachineDeployments…
```

You can also check the full documentation for the upgrade process: [KubeOne Upgrade Process](https://docs.kubermatic.com/kubeone/master/using_kubeone/upgrading_cluster/)

During the upgrade process you can watch the state in a **SECOND** shell by:
```bash
watch kubectl -n kube-system get md,ma,node
```

#### Check/confirm status of the new upgrade version:
After the upgrade process is finished check

```bash
kubectl version --short
```
```
Client Version: v1.21.1
Server Version: v1.20.7
```
```bash
kubeone status -t .
```
```bash
kubectl get nodes
```
```
NAME                                                STATUS   ROLES    AGE     VERSION
k1-control.1.test-00-kubermatic Ready    master   24h     v1.20.7
k1-control.2.test-00-kubermatic Ready    master   24h     v1.20.7
k1-control.3.test-00-kubermatic Ready    master   24h     v1.20.7
k1-pool-az-a-75dfcdb6cb-4ms69       Ready    <none>   5m54s   v1.20.7
k1-pool-az-a-75dfcdb6cb-bfxk2       Ready    <none>   8m5s    v1.20.7
k1-pool-az-a-75dfcdb6cb-pn2n5       Ready    <none>   3m53s   v1.20.7
```

### 2. Option: Upgrade first master nodes and then the workers

The second option would be to use KubeOne `kubeone apply` command only to upgrade only the master nodes and later the MachineDeployments or static workers.

***Please ensure your terraform state is up to date***.

```bash
terraform refresh
kubeone apply -t . -m ../kubeone.yaml --verbose
```

If you take this route then you will have to upgrade the worker nodes manually by editing all the MachineDeployment objects after upgrading the master nodes. Therefore you need change the **`spec.template.spec.providerSpec.versions.kubelet`** section to `1.20.7`

```
vim ../machines/md-zonne-a.yaml
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
            preemptible: false
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
        kubelet: 1.19.9  << UPDATE to 1.20.7
```
Or use `sed`:
```
sed -i 's/1.19.9/1.20.7/g' ../machines/*.yaml
kubectl apply -f ../machines
```

When you save and exit the editor or applied the modified manifests, the machine-controller will detect the changes and proceed to update the worker nodes according to the new specification. The upgrade uses a rolling-update style (just like the normal Kubernetes deployment controller) i.e. old worker nodes will not be deleted until the status of the newly provisioned node with the new Kubernetes version becomes ready, then it will proceed to upgrade the remaining worker nodes in a similar fashion (depending on the number of replica) until all of them are upgraded to the desired Kubernetes version.


After a while check your updated cluster nodes:
```bash
kubectl get md,ms,ma,nodes -A

NAMESPACE     NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.20.7    2d
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.20.7    38h
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.20.7    38h

NAMESPACE     NAME                                                REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
kube-system   machineset.cluster.k8s.io/k1-pool-az-a-584d589c8c   1                               gce        ubuntu   1.20.7    108s
kube-system   machineset.cluster.k8s.io/k1-pool-az-a-7f976c98dd   0                               gce        ubuntu   1.19.9    2d
kube-system   machineset.cluster.k8s.io/k1-pool-az-a-bd95f5c65    1          1                    gce        ubuntu   1.19.9    37h
kube-system   machineset.cluster.k8s.io/k1-pool-az-b-6996d8f668   1          1                    gce        ubuntu   1.19.9    37h
kube-system   machineset.cluster.k8s.io/k1-pool-az-b-6b7fcd6985   0                               gce        ubuntu   1.19.9    38h
kube-system   machineset.cluster.k8s.io/k1-pool-az-b-7c455dc654   1                               gce        ubuntu   1.20.7    108s
kube-system   machineset.cluster.k8s.io/k1-pool-az-c-66f96d6b66   0                               gce        ubuntu   1.19.9    38h
kube-system   machineset.cluster.k8s.io/k1-pool-az-c-77478767d5   1                               gce        ubuntu   1.20.7    108s
kube-system   machineset.cluster.k8s.io/k1-pool-az-c-7bdfbcd567   1          1                    gce        ubuntu   1.19.9    37h

NAMESPACE     NAME                                                   PROVIDER   OS       ADDRESS                         KUBELET   AGE
kube-system   machine.cluster.k8s.io/k1-pool-az-a-584d589c8c-7f9gb   gce        ubuntu   10.240.0.23                     1.20.7    108s
kube-system   machine.cluster.k8s.io/k1-pool-az-a-bd95f5c65-lm4fj    gce        ubuntu   10.240.0.19                     1.19.9    6h50m
kube-system   machine.cluster.k8s.io/k1-pool-az-b-6996d8f668-kx96z   gce        ubuntu   10.240.0.20                     1.19.9    6h50m
kube-system   machine.cluster.k8s.io/k1-pool-az-b-7c455dc654-j2ggk   gce        ubuntu   k1-pool-az-b-7c455dc654-j2ggk   1.20.7    108s
kube-system   machine.cluster.k8s.io/k1-pool-az-c-77478767d5-vffmd   gce        ubuntu   10.240.0.25                     1.20.7    108s
kube-system   machine.cluster.k8s.io/k1-pool-az-c-7bdfbcd567-kdfn2   gce        ubuntu   10.240.0.22                     1.19.9    6h50m

NAMESPACE   NAME                                 STATUS   ROLES                  AGE     VERSION
            node/k1-control-plane-1              Ready    control-plane,master   2d      v1.20.7
            node/k1-control-plane-2              Ready    control-plane,master   38h     v1.20.7
            node/k1-control-plane-3              Ready    control-plane,master   38h     v1.20.7
            node/k1-pool-az-a-bd95f5c65-lm4fj    Ready    <none>                 6h48m   v1.19.9
            node/k1-pool-az-b-6996d8f668-kx96z   Ready    <none>                 6h47m   v1.19.9
            node/k1-pool-az-c-7bdfbcd567-kdfn2   Ready    <none>                 6h48m   v1.19.9
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

The property `maxUnavailable: 0` ensures, that every time during the update the capacity of the cluster will be stable. Anyway nodes get rescheduled by draining, what could influence your Application. To ensure rolling update of Nodes don't have an impact to your workload, check if your Application:
- Is managed by a higher object controller like `Deployment`
- Replica count is higher as `1`. If only `1` replica is there, a short downtime during rescheduling is for sure present
- Clients talking through a service to your set of pods
- Host Anti-Affinity - Pods of get placed on different hosts or availability zones
- Higher ensures could be achieved by [Quality Classes](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/) and/or [Pod disruption budgets](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets)

### OS Upgrades

At Ubuntu it's recommended to set the flag `distUpgradeOnBoot: true` in the `MachineDeployment:
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

For Flatcar Linux, Kubeone installs automatically the Flatcar OS update operator [kinvolk/flatcar-linux-update-operator](https://github.com/kinvolk/flatcar-linux-update-operator) what mange the upgrades if your spec is:
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
