# Cluster Optimization of Worker nodes
As you may have already expected, some resources of the worker node are currently not really used. So let's lower our cloud costs and optimize our workers nodes by following this guide.

## Optimize GCE Worker nodes

If we take a look at the current resource consumption of the nodes, we see that we only use a minimal amount of resources.

```bash
kubectl top node
```

```text
NAME                            CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
k1-control-plane-1              237m         11%    2404Mi          32%       
k1-control-plane-2              172m         8%     1777Mi          24%       
k1-control-plane-3              180m         9%     1762Mi          24%       
k1-pool-az-a-7d8ff98f97-hfg4q   75m          4%     545Mi           7%        
k1-pool-az-b-9cd4b758-p7tnm     62m          3%     527Mi           7%        
k1-pool-az-c-55fcfd9699-65lhq   56m          3%     541Mi           7%
```

Due to this we want to:
- use the cheapest node type of gce `n1-standard-1`
- change the disk size to `20`
- start a rolling update without any downtime

As we already created our MachineDeployment yaml definitions, we can now easily update them and apply the change. For a full list of options of the machine deployment spec, see [github.com/kubermatic/machine-controller -> examples/gce-machinedeployment.yaml](https://github.com/kubermatic/machine-controller/blob/main/examples/gce-machinedeployment.yaml).

```bash
cd $TRAINING_DIR/src/gce
ls -l machines/
```

```text
total 12
-rw-r--r-- 1 kubermatic root 2173 Aug 18 10:43 md-zone-a.yaml
-rw-r--r-- 1 kubermatic root 2173 Aug 18 10:44 md-zone-b.yaml
-rw-r--r-- 1 kubermatic root 2173 Aug 18 10:44 md-zone-c.yaml
```

Take a close look at the definitions and change the following fields:
- `spec.template.spec.providerSpec.value.cloudProviderSpec.diskSize`
- `spec.template.spec.providerSpec.value.cloudProviderSpec.machineType`

```bash
cat machines/md-zone-a.yaml | yq '.spec.template.spec.providerSpec.value.cloudProviderSpec'
```

First change these fields value in `machines/md-zone-a.yaml` and see the diff:

```bash
diff machines/md-zone-a.yaml machines/md-zone-b.yaml 
```

```text
9,10c9,10
<   name: k1-pool-az-a
<   selfLink: /apis/cluster.k8s.io/v1alpha1/namespaces/kube-system/machinedeployments/k1-pool-az-a
---
>   name: k1-pool-az-b
>   selfLink: /apis/cluster.k8s.io/v1alpha1/namespaces/kube-system/machinedeployments/k1-pool-az-b
18c18
<       workerset: k1-pool-az-a
---
>       workerset: k1-pool-az-b
28c28
<         workerset: k1-pool-az-a
---
>         workerset: k1-pool-az-b
34c34
<           workerset: k1-pool-az-a
---
>           workerset: k1-pool-az-b
40c40
<             diskSize: 20
---
>             diskSize: 50
43,44c43,44
<               k1-workers: pool-az-a
<             machineType: n1-standard-1
---
>               k1-workers: pool-az-b
>             machineType: n1-standard-2
53,54c53,54
<             - k1-pool-az-a
<             zone: europe-west4-a
---
>             - k1-pool-az-b
>             zone: europe-west4-b
```

We should see changed fields. Now apply the change of the first `machinedeployment`:

```bash
kubectl -n kube-system apply -f machines/md-zone-a.yaml
```

You should now see that a new `machine`object has been created:

```bash
kubectl -n kube-system get md,ma,node
```

```text
NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.31.8    31m
machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.31.8    10m
machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.31.8    10m

NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS         AGE
machine.cluster.k8s.io/k1-pool-az-a-5579764bfb-7cwxh   gce        ubuntu   k1-pool-az-a-5579764bfb-7cwxh   1.31.8    34.90.198.72    31m
machine.cluster.k8s.io/k1-pool-az-a-7fb4567dbf-r9w2h   gce        ubuntu                                   1.31.8                    9s
machine.cluster.k8s.io/k1-pool-az-b-576d85b5d9-2tn9s   gce        ubuntu   k1-pool-az-b-576d85b5d9-2tn9s   1.31.8    34.34.126.230   10m
machine.cluster.k8s.io/k1-pool-az-c-6cff495854-tpg4p   gce        ubuntu   k1-pool-az-c-6cff495854-tpg4p   1.31.8    34.141.237.8    10m

NAME                                 STATUS   ROLES           AGE     VERSION
node/k1-control-plane-1              Ready    control-plane   35m     v1.31.8
node/k1-control-plane-2              Ready    control-plane   25m     v1.31.8
node/k1-control-plane-3              Ready    control-plane   25m     v1.31.8
node/k1-pool-az-a-5579764bfb-7cwxh   Ready    <none>          29m     v1.31.8
node/k1-pool-az-b-576d85b5d9-2tn9s   Ready    <none>          8m9s    v1.31.8
node/k1-pool-az-c-6cff495854-tpg4p   Ready    <none>          7m55s   v1.31.8
```

Now update the files `machines/md-zone-b.yaml` and `machines/md-zone-c.yaml` in the same way and apply the final config of all MachineDeployments:

```bash
kubectl -n kube-system apply -f machines/
```

Watch what happens in your cluster. The machine-controller will manage the changes for you:
- for every change a new `machine` object will be created 
- the machine-controller will wait until the node is healthy and then drain and delete the old node
- due to the `spec.strategy.rollingUpdate.maxUnavailable=0` setting, no downtime will occur

```bash
watch kubectl -n kube-system get md,ma,node -o wide
```

```text
NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE   DELETED
machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.31.8    33m
machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.31.8    12m
machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.31.8    12m

NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS         AGE     DELETED
machine.cluster.k8s.io/k1-pool-az-a-5579764bfb-7cwxh   gce        ubuntu   k1-pool-az-a-5579764bfb-7cwxh   1.31.8    34.90.198.72    33m
machine.cluster.k8s.io/k1-pool-az-a-7fb4567dbf-r9w2h   gce        ubuntu   k1-pool-az-a-7fb4567dbf-r9w2h   1.31.8    34.90.186.177   2m11s
machine.cluster.k8s.io/k1-pool-az-b-576d85b5d9-2tn9s   gce        ubuntu   k1-pool-az-b-576d85b5d9-2tn9s   1.31.8    34.34.126.230   12m
machine.cluster.k8s.io/k1-pool-az-b-7d57bb75dd-67rll   gce        ubuntu                                   1.31.8    34.91.242.26    44s
machine.cluster.k8s.io/k1-pool-az-c-6cff495854-tpg4p   gce        ubuntu   k1-pool-az-c-6cff495854-tpg4p   1.31.8    34.141.237.8    12m
machine.cluster.k8s.io/k1-pool-az-c-7b7fd67fb7-pq5xr   gce        ubuntu                                   1.31.8    34.90.164.10    24s

NAME                                 STATUS     ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP     OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
node/k1-control-plane-1              Ready      control-plane   37m     v1.31.8   10.164.0.10   34.32.186.68    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-control-plane-2              Ready      control-plane   27m     v1.31.8   10.164.0.12   34.147.92.22    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-control-plane-3              Ready      control-plane   27m     v1.31.8   10.164.0.13   34.34.14.114    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-pool-az-a-5579764bfb-7cwxh   Ready      <none>          31m     v1.31.8   10.164.0.11   34.90.198.72    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-pool-az-a-7fb4567dbf-r9w2h   NotReady   <none>          8s      v1.31.8   10.164.0.16   34.90.186.177   Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-pool-az-b-576d85b5d9-2tn9s   Ready      <none>          10m     v1.31.8   10.164.0.14   34.34.126.230   Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-pool-az-c-6cff495854-tpg4p   Ready      <none>          9m57s   v1.31.8   10.164.0.15   34.141.237.8    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
```

After a few minutes we will see that all new nodes are ready:

```text
NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE   DELETED
machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.31.8    37m
machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.31.8    16m
machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.31.8    16m

NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS         AGE     DELETED
machine.cluster.k8s.io/k1-pool-az-a-7fb4567dbf-r9w2h   gce        ubuntu   k1-pool-az-a-7fb4567dbf-r9w2h   1.31.8    34.90.186.177   6m11s
machine.cluster.k8s.io/k1-pool-az-b-7d57bb75dd-67rll   gce        ubuntu   k1-pool-az-b-7d57bb75dd-67rll   1.31.8    34.91.242.26    4m44s
machine.cluster.k8s.io/k1-pool-az-c-7b7fd67fb7-pq5xr   gce        ubuntu   k1-pool-az-c-7b7fd67fb7-pq5xr   1.31.8    34.90.164.10    4m24s

NAME                                 STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP     OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
node/k1-control-plane-1              Ready    control-plane   41m     v1.31.8   10.164.0.10   34.32.186.68    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-control-plane-2              Ready    control-plane   31m     v1.31.8   10.164.0.12   34.147.92.22    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-control-plane-3              Ready    control-plane   31m     v1.31.8   10.164.0.13   34.34.14.114    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-pool-az-a-7fb4567dbf-r9w2h   Ready    <none>          4m8s    v1.31.8   10.164.0.16   34.90.186.177   Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-pool-az-b-7d57bb75dd-67rll   Ready    <none>          2m40s   v1.31.8   10.164.0.17   34.91.242.26    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
node/k1-pool-az-c-7b7fd67fb7-pq5xr   Ready    <none>          2m27s   v1.31.8   10.164.0.18   34.90.164.10    Ubuntu 24.04.2 LTS   6.11.0-1014-gcp   containerd://1.7.27
```

Finally, verify that your app is still running and reachable:

```bash
curl https://app-ext.$DNS_ZONE.cloud-native.training 
```

See also the resource usage:

```bash
kubectl top node
```

## Scale down to zero

For some use cases where you may not have production workload running, you can also scale down your worker nodes to `0`. This can save cost and can be automated e.g. by a cronjob as well.

```bash
kubectl -n kube-system scale machinedeployment --all --replicas=0
```

```text
machinedeployment.cluster.k8s.io/k1-pool-az-a scaled
machinedeployment.cluster.k8s.io/k1-pool-az-b scaled
machinedeployment.cluster.k8s.io/k1-pool-az-c scaled
```

Verify that your nodes were removed. After a while all the `machine` objects and the corresponding`node` objects should be gone:

```bash
watch kubectl -n kube-system get md,ma,node
``` 

```text
NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
machinedeployment.cluster.k8s.io/k1-pool-az-a   0                               gce        ubuntu   1.31.8    38m
machinedeployment.cluster.k8s.io/k1-pool-az-b   0                               gce        ubuntu   1.31.8    17m
machinedeployment.cluster.k8s.io/k1-pool-az-c   0                               gce        ubuntu   1.31.8    17m

NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS         AGE
machine.cluster.k8s.io/k1-pool-az-a-7fb4567dbf-r9w2h   gce        ubuntu   k1-pool-az-a-7fb4567dbf-r9w2h   1.31.8    34.90.186.177   7m19s
machine.cluster.k8s.io/k1-pool-az-b-7d57bb75dd-67rll   gce        ubuntu   k1-pool-az-b-7d57bb75dd-67rll   1.31.8    34.91.242.26    5m52s
machine.cluster.k8s.io/k1-pool-az-c-7b7fd67fb7-pq5xr   gce        ubuntu   k1-pool-az-c-7b7fd67fb7-pq5xr   1.31.8    34.90.164.10    5m32s

NAME                                 STATUS                     ROLES           AGE     VERSION
node/k1-control-plane-1              Ready                      control-plane   42m     v1.31.8
node/k1-control-plane-2              Ready                      control-plane   32m     v1.31.8
node/k1-control-plane-3              Ready                      control-plane   32m     v1.31.8
node/k1-pool-az-a-7fb4567dbf-r9w2h   Ready,SchedulingDisabled   <none>          5m17s   v1.31.8
node/k1-pool-az-b-7d57bb75dd-67rll   Ready,SchedulingDisabled   <none>          3m49s   v1.31.8
node/k1-pool-az-c-7b7fd67fb7-pq5xr   Ready,SchedulingDisabled   <none>          3m36s   v1.31.8
```

After a few minutes, verify that your app is still running and reachable:

```bash
curl https://app-ext.$DNS_ZONE.cloud-native.training
```

Now you see the app is not reachable anymore, as no compute worker nodes are available:

```text
curl: (7) Failed to connect to app-ext.YOUR_DNS_ZONE.cloud-native.training port 443: Connection refused
```

```bash
kubectl get nodes
```

```text
NAME                            STATUS                     ROLES           AGE     VERSION
k1-control-plane-1              Ready                      control-plane   43m     v1.31.8
k1-control-plane-2              Ready                      control-plane   33m     v1.31.8
k1-control-plane-3              Ready                      control-plane   33m     v1.31.8
```

## Scale MachineDeployments back to one

```bash
kubectl -n kube-system scale machinedeployment --all --replicas=1
```

## Cleanup test application Kubernetes Resources

We won't use the `app-ext` anymore, so you can safely clean the related resources.

```bash
cd $TRAINING_DIR/07_deploy-app-02-external-access
# delete application manifests
kubectl delete -f manifests/
# delete namespace
kubectl config set-context --current --namespace=default
kubectl delete ns app-ext
```

Jump > [**Home**](../README.md) | Previous > [**Application with External Access**](../07_deploy-app-02-external-access/README.md) | Next > [**Velero Backup Process**](../09_backup_velero/README.md)