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
machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.29.10   8h
machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.29.10   7h52m
machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.29.10   7h52m

NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS          AGE
machine.cluster.k8s.io/k1-pool-az-a-79f5bd4cfb-4wt22   gce        ubuntu                                   1.29.10   34.90.100.55     34s
machine.cluster.k8s.io/k1-pool-az-a-7d8ff98f97-hfg4q   gce        ubuntu   k1-pool-az-a-7d8ff98f97-hfg4q   1.29.10   34.32.151.12     3h11m
machine.cluster.k8s.io/k1-pool-az-b-9cd4b758-p7tnm     gce        ubuntu   k1-pool-az-b-9cd4b758-p7tnm     1.29.10   34.91.198.135    3h11m
machine.cluster.k8s.io/k1-pool-az-c-55fcfd9699-65lhq   gce        ubuntu   k1-pool-az-c-55fcfd9699-65lhq   1.29.10   35.204.113.253   3h11m

NAME                                 STATUS   ROLES           AGE    VERSION
node/k1-control-plane-1              Ready    control-plane   8h     v1.29.10
node/k1-control-plane-2              Ready    control-plane   8h     v1.29.10
node/k1-control-plane-3              Ready    control-plane   8h     v1.29.10
node/k1-pool-az-a-7d8ff98f97-hfg4q   Ready    <none>          3h8m   v1.29.10
node/k1-pool-az-b-9cd4b758-p7tnm     Ready    <none>          3h8m   v1.29.10
node/k1-pool-az-c-55fcfd9699-65lhq   Ready    <none>          3h8m   v1.29.10
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
NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE     DELETED
machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.29.10   8h
machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.29.10   7h55m
machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.29.10   7h55m

NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS          AGE     DELET
ED
machine.cluster.k8s.io/k1-pool-az-a-79f5bd4cfb-4wt22   gce        ubuntu   k1-pool-az-a-79f5bd4cfb-4wt22   1.29.10   34.90.100.55     3m12s
machine.cluster.k8s.io/k1-pool-az-a-7d8ff98f97-hfg4q   gce        ubuntu   k1-pool-az-a-7d8ff98f97-hfg4q   1.29.10   34.32.151.12     3h13m
machine.cluster.k8s.io/k1-pool-az-b-7f57864779-kzwpl   gce        ubuntu                                   1.29.10                    21s
machine.cluster.k8s.io/k1-pool-az-b-9cd4b758-p7tnm     gce        ubuntu   k1-pool-az-b-9cd4b758-p7tnm     1.29.10   34.91.198.135    3h13m
machine.cluster.k8s.io/k1-pool-az-c-55fcfd9699-65lhq   gce        ubuntu   k1-pool-az-c-55fcfd9699-65lhq   1.29.10   35.204.113.253   3h13m
machine.cluster.k8s.io/k1-pool-az-c-b6b95c4-zg4cg      gce        ubuntu                                   1.29.10                    20s

NAME                                 STATUS     ROLES           AGE     VERSION    INTERNAL-IP   EXTERNAL-IP      OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
node/k1-control-plane-1              Ready      control-plane   8h      v1.29.10   10.164.0.26   34.141.155.202   Ubuntu 22.04.5 LTS   6.8.0-1017-gcp   containerd://1.6.33
node/k1-control-plane-2              Ready      control-plane   8h      v1.29.10   10.164.0.29   34.141.232.14    Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
node/k1-control-plane-3              Ready      control-plane   8h      v1.29.10   10.164.0.28   35.234.171.179   Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
node/k1-pool-az-a-79f5bd4cfb-4wt22   NotReady   <none>          34s     v1.29.10   10.164.0.36   34.90.100.55     Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
node/k1-pool-az-a-7d8ff98f97-hfg4q   Ready      <none>          3h11m   v1.29.10   10.164.0.33   34.32.151.12     Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
node/k1-pool-az-b-9cd4b758-p7tnm     Ready      <none>          3h11m   v1.29.10   10.164.0.34   34.91.198.135    Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
node/k1-pool-az-c-55fcfd9699-65lhq   Ready      <none>          3h11m   v1.29.10   10.164.0.35   35.204.113.253   Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
```

After a few minutes we will see that all new nodes are ready:

```text
NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE   DELETED
machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.29.10   8h
machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.29.10   8h
machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.29.10   8h

NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS        AGE   DELETED
machine.cluster.k8s.io/k1-pool-az-a-79f5bd4cfb-4wt22   gce        ubuntu   k1-pool-az-a-79f5bd4cfb-4wt22   1.29.10   34.90.100.55   16m
machine.cluster.k8s.io/k1-pool-az-b-7f57864779-kzwpl   gce        ubuntu   k1-pool-az-b-7f57864779-kzwpl   1.29.10   34.90.94.98    13m
machine.cluster.k8s.io/k1-pool-az-c-b6b95c4-zg4cg      gce        ubuntu   k1-pool-az-c-b6b95c4-zg4cg      1.29.10   34.34.49.93    13m

NAME                                 STATUS   ROLES           AGE   VERSION    INTERNAL-IP   EXTERNAL-IP      OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
node/k1-control-plane-1              Ready    control-plane   8h    v1.29.10   10.164.0.26   34.141.155.202   Ubuntu 22.04.5 LTS   6.8.0-1017-gcp   containerd://1.6.33
node/k1-control-plane-2              Ready    control-plane   8h    v1.29.10   10.164.0.29   34.141.232.14    Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
node/k1-control-plane-3              Ready    control-plane   8h    v1.29.10   10.164.0.28   35.234.171.179   Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
node/k1-pool-az-a-79f5bd4cfb-4wt22   Ready    <none>          13m   v1.29.10   10.164.0.36   34.90.100.55     Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
node/k1-pool-az-b-7f57864779-kzwpl   Ready    <none>          11m   v1.29.10   10.164.0.37   34.90.94.98      Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
node/k1-pool-az-c-b6b95c4-zg4cg      Ready    <none>          10m   v1.29.10   10.164.0.38   34.34.49.93      Ubuntu 22.04.5 LTS   6.8.0-1015-gcp   containerd://1.6.33
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
machinedeployment.cluster.k8s.io/k1-pool-az-a   0                               gce        ubuntu   1.29.10   8h
machinedeployment.cluster.k8s.io/k1-pool-az-b   0                               gce        ubuntu   1.29.10   8h
machinedeployment.cluster.k8s.io/k1-pool-az-c   0                               gce        ubuntu   1.29.10   8h

NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS        AGE
machine.cluster.k8s.io/k1-pool-az-a-79f5bd4cfb-4wt22   gce        ubuntu   k1-pool-az-a-79f5bd4cfb-4wt22   1.29.10   34.90.100.55   19m
machine.cluster.k8s.io/k1-pool-az-b-7f57864779-kzwpl   gce        ubuntu   k1-pool-az-b-7f57864779-kzwpl   1.29.10   34.90.94.98    16m
machine.cluster.k8s.io/k1-pool-az-c-b6b95c4-zg4cg      gce        ubuntu   k1-pool-az-c-b6b95c4-zg4cg      1.29.10   34.34.49.93    16m

NAME                                 STATUS                     ROLES           AGE   VERSION
node/k1-control-plane-1              Ready                      control-plane   8h    v1.29.10
node/k1-control-plane-2              Ready                      control-plane   8h    v1.29.10
node/k1-control-plane-3              Ready                      control-plane   8h    v1.29.10
node/k1-pool-az-a-79f5bd4cfb-4wt22   Ready,SchedulingDisabled   <none>          16m   v1.29.10
node/k1-pool-az-b-7f57864779-kzwpl   Ready,SchedulingDisabled   <none>          14m   v1.29.10
node/k1-pool-az-c-b6b95c4-zg4cg      Ready,SchedulingDisabled   <none>          13m   v1.29.10
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
NAME                            STATUS                     ROLES           AGE   VERSION
k1-control-plane-1              Ready                      control-plane   8h    v1.29.10
k1-control-plane-2              Ready                      control-plane   8h    v1.29.10
k1-control-plane-3              Ready                      control-plane   8h    v1.29.10
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

You can optionally delete the cert-manager at this moment.

```bash
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml
```

Jump > [**Home**](../README.md) | Previous > [**Application with External Access**](../07_deploy-app-02-external-access/README.md) | Next > [**Velero Backup Process**](../09_backup_velero/README.md)