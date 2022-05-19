# Cluster Optimization of Worker nodes
As you may have already expected, some resources of the worker node are currently not really used. So let's lower our cloud costs and optimize our workers nodes by following this guide.

## Optimize GCE Worker nodes

If we take a look at the current resource consumption of the nodes, we see that we only use a minimal amount of resources.

```bash
kubectl top node
```

```text
NAME                            CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
k1-control-plane-1              197m         9%     1696Mi          23%       
k1-control-plane-2              171m         8%     1469Mi          19%       
k1-control-plane-3              165m         8%     1640Mi          22%       
k1-pool-az-a-75cddb6cd9-slgqk   79m          4%     848Mi           11%       
k1-pool-az-b-777d7cc84b-g76zf   80m          4%     869Mi           12%       
k1-pool-az-c-5d5cfcc5bf-gpjpg   99m          5%     959Mi           13% 
```

Due to this we want to:
- use the cheapest node type of gce `n1-standard-1`
- change the disk size to `20`
- start a rolling update without any downtime

As we already created our MachineDeployment yaml definitions, we can now easily update them and apply the change. For a full list of options of the machine deployment spec, see [github.com/kubermatic/machine-controller -> examples/gce-machinedeployment.yaml](https://github.com/kubermatic/machine-controller/blob/master/examples/gce-machinedeployment.yaml).

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
NAMESPACE     NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        coreos   1.22.5    4h47m
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.22.5    78m
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.22.5    78m

NAMESPACE     NAME                                                   PROVIDER   OS       ADDRESS       KUBELET   AGE
kube-system   machine.cluster.k8s.io/k1-pool-az-a-6d996bd447-8skhq   gce        coreos                 1.22.5    16s
kube-system   machine.cluster.k8s.io/k1-pool-az-a-75cddb6cd9-slgqk   gce        ubuntu   10.240.0.13   1.22.5    78m
kube-system   machine.cluster.k8s.io/k1-pool-az-b-777d7cc84b-g76zf   gce        ubuntu   10.240.0.15   1.22.5    78m
kube-system   machine.cluster.k8s.io/k1-pool-az-c-5d5cfcc5bf-gpjpg   gce        ubuntu   10.240.0.14   1.22.5    78m

NAMESPACE   NAME                                 STATUS   ROLES    AGE     VERSION
            node/k1-control-plane-1              Ready    master   5h25m   v1.22.5
            node/k1-control-plane-2              Ready    master   4h49m   v1.22.5
            node/k1-control-plane-3              Ready    master   4h48m   v1.22.5
            node/k1-pool-az-a-75cddb6cd9-slgqk   Ready    <none>   75m     v1.22.5
            node/k1-pool-az-b-777d7cc84b-g76zf   Ready    <none>   75m     v1.22.5
            node/k1-pool-az-c-5d5cfcc5bf-gpjpg   Ready    <none>   75m     v1.22.5
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
machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.22.5    11h   
machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.22.5    66m   
machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.22.5    66m   

NAME                                                   PROVIDER   OS       MACHINESET                NODE                            ADDRESS       KUBELET   AGE     DELETED
machine.cluster.k8s.io/k1-pool-az-a-7f976c98dd-fp4xt   gce        ubuntu   k1-pool-az-a-7f976c98dd   k1-pool-az-a-7f976c98dd-fp4xt   10.240.0.7    1.22.5    78m     5s
machine.cluster.k8s.io/k1-pool-az-a-bd95f5c65-pmzfb    gce        ubuntu   k1-pool-az-a-bd95f5c65    k1-pool-az-a-bd95f5c65-pmzfb    10.240.0.10   1.22.5    2m50s   
machine.cluster.k8s.io/k1-pool-az-b-6996d8f668-2wfp4   gce        ubuntu   k1-pool-az-b-6996d8f668                                   10.240.0.11   1.22.5    2m4s    
machine.cluster.k8s.io/k1-pool-az-b-6b7fcd6985-wd6fm   gce        ubuntu   k1-pool-az-b-6b7fcd6985   k1-pool-az-b-6b7fcd6985-wd6fm   10.240.0.8    1.22.5    66m     
machine.cluster.k8s.io/k1-pool-az-c-66f96d6b66-nvjfk   gce        ubuntu   k1-pool-az-c-66f96d6b66   k1-pool-az-c-66f96d6b66-nvjfk   10.240.0.9    1.22.5    66m     
machine.cluster.k8s.io/k1-pool-az-c-7bdfbcd567-cb5kb   gce        ubuntu   k1-pool-az-c-7bdfbcd567                                   10.240.0.12   1.22.5    2m4s    

NAME                                 STATUS                     ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP      OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
node/k1-control-plane-1              Ready                      master   11h   v1.22.5   10.240.0.2    34.141.138.245   Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.14
node/k1-control-plane-2              Ready                      master   84m   v1.22.5   10.240.0.4    34.141.210.40    Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.14
node/k1-control-plane-3              Ready                      master   83m   v1.22.5   10.240.0.5    34.141.148.120   Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.14
node/k1-pool-az-a-7f976c98dd-fp4xt   Ready,SchedulingDisabled   <none>   75m   v1.22.5   10.240.0.7    34.141.201.46    Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.13
node/k1-pool-az-a-bd95f5c65-pmzfb    Ready                      <none>   26s   v1.22.5   10.240.0.10   34.141.168.104   Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.13
node/k1-pool-az-b-6b7fcd6985-wd6fm   Ready                      <none>   63m   v1.22.5   10.240.0.8    34.91.8.207      Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.13
node/k1-pool-az-c-66f96d6b66-nvjfk   Ready                      <none>   64m   v1.22.5   10.240.0.9    34.141.205.68    Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.13
```

After a few minutes we will see that all new nodes are ready:

```text
machinedeployment.cluster.k8s.io/k1-pool-az-a   1          1                    gce        ubuntu   1.22.5    11h   
machinedeployment.cluster.k8s.io/k1-pool-az-b   1          1                    gce        ubuntu   1.22.5    68m   
machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.22.5    68m   

NAME                                                   PROVIDER   OS       MACHINESET                NODE                            ADDRESS       KUBELET   AGE     DELETED
machine.cluster.k8s.io/k1-pool-az-a-bd95f5c65-pmzfb    gce        ubuntu   k1-pool-az-a-bd95f5c65    k1-pool-az-a-bd95f5c65-pmzfb    10.240.0.10   1.22.5    5m11s   
machine.cluster.k8s.io/k1-pool-az-b-6996d8f668-2wfp4   gce        ubuntu   k1-pool-az-b-6996d8f668   k1-pool-az-b-6996d8f668-2wfp4   10.240.0.11   1.22.5    4m25s   
machine.cluster.k8s.io/k1-pool-az-c-7bdfbcd567-cb5kb   gce        ubuntu   k1-pool-az-c-7bdfbcd567   k1-pool-az-c-7bdfbcd567-cb5kb   10.240.0.12   1.22.5    4m25s   

NAME                                 STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP      OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
node/k1-control-plane-1              Ready    master   11h     v1.22.5   10.240.0.2    34.141.138.245   Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.14
node/k1-control-plane-2              Ready    master   86m     v1.22.5   10.240.0.4    34.141.210.40    Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.14
node/k1-control-plane-3              Ready    master   85m     v1.22.5   10.240.0.5    34.141.148.120   Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.14
node/k1-pool-az-a-bd95f5c65-pmzfb    Ready    <none>   2m47s   v1.22.5   10.240.0.10   34.141.168.104   Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.13
node/k1-pool-az-b-6996d8f668-2wfp4   Ready    <none>   2m7s    v1.22.5   10.240.0.11   34.91.242.55     Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.13
node/k1-pool-az-c-7bdfbcd567-cb5kb   Ready    <none>   2m15s   v1.22.5   10.240.0.12   34.141.216.253   Ubuntu 18.04.5 LTS   5.4.0-1043-gcp   docker://19.3.13
```

Finally, verify that your app is still running and reachable:

```bash
curl https://app-ext.$DNS_ZONE.loodse.training 
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
machinedeployment.cluster.k8s.io/k1-pool-az-a   0                               gce        ubuntu   1.22.5    11h
machinedeployment.cluster.k8s.io/k1-pool-az-b   0                               gce        ubuntu   1.22.5    69m
machinedeployment.cluster.k8s.io/k1-pool-az-c   0                               gce        ubuntu   1.22.5    69m

NAME                                                   PROVIDER   OS       ADDRESS       KUBELET   AGE
machine.cluster.k8s.io/k1-pool-az-a-bd95f5c65-pmzfb    gce        ubuntu   10.240.0.10   1.22.5    6m5s
machine.cluster.k8s.io/k1-pool-az-b-6996d8f668-2wfp4   gce        ubuntu   10.240.0.11   1.22.5    5m19s
machine.cluster.k8s.io/k1-pool-az-c-7bdfbcd567-cb5kb   gce        ubuntu   10.240.0.12   1.22.5    5m19s

NAME                                 STATUS                     ROLES    AGE     VERSION
node/k1-control-plane-1              Ready                      master   11h     v1.22.5
node/k1-control-plane-2              Ready                      master   87m     v1.22.5
node/k1-control-plane-3              Ready                      master   86m     v1.22.5
node/k1-pool-az-a-bd95f5c65-pmzfb    Ready,SchedulingDisabled   <none>   3m41s   v1.22.5
node/k1-pool-az-b-6996d8f668-2wfp4   Ready,SchedulingDisabled   <none>   3m1s    v1.22.5
node/k1-pool-az-c-7bdfbcd567-cb5kb   Ready,SchedulingDisabled   <none>   3m9s    v1.22.5
```

After a few minutes, verify that your app is still running and reachable:

```bash
curl https://app-ext.$DNS_ZONE.loodse.training
```

Now you see the app is not reachable anymore, as now compute worker nodes are available:

```text
curl: (7) Failed to connect to app-ext.YOUR_DNS_ZONE.loodse.training port 443: Connection refused
```

```bash
kubectl get nodes
```

```text
NAME                 STATUS   ROLES    AGE   VERSION
k1-control-plane-1   Ready    master   11h   v1.22.5
k1-control-plane-2   Ready    master   90m   v1.22.5
k1-control-plane-3   Ready    master   88m   v1.22.5
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
kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.yaml
```

Jump > [**Home**](../README.md) | Previous > [**Application with External Access**](../07_deploy-app-02-external-access/README.md) | Next > [**Velero Backup Process**](../09_backup_velero/README.md)