# Cluster AutoScaling

First we need to deploy the cluster autoscaler controller. KubeOne is shipped with some [embedded addons](https://docs.kubermatic.com/kubeone/v1.8/guides/addons/#activate-embedded-addons).

Let's enable `cluster-autoscaler` one through `kubeone.yaml` file:


```yaml
# src/gce/kubeone.yaml

apiVersion: kubeone.k8c.io/v1beta2
kind: KubeOneCluster
name: k1
versions:
  kubernetes: "1.32.4"
cloudProvider:
  gce: {}
  cloudConfig: |-
    [global]
    regional = true
addons:
  enable: true
  # In case when the relative path is provided, the path is relative
  # to the KubeOne configuration file.
  path: "./addons"
  addons:                       # <<< Add
  - name: cluster-autoscaler    # <<< Add
```

Deploy the Cluster Autoscaler addon:

```bash
cd $TRAINING_DIR/src/gce
kubeone apply -t ./tf-infra/
```

## Upscale

Now deploy our test application with quite high CPU reservation of `250m` => 1/4 core * 5 pods. This should lead to pending pods. If not, just scale up your application replica.

```bash
kubectl create ns app-ext
kubectl config set-context --current --namespace=app-ext
```
or
```bash
kcns app-ext
```

```bash
kubectl apply -f ../../12_cluster-autoscaling/deploy.scale.yaml
```
Check the pods in the namespace
```bash
kubectl get pods
```

```text
NAME                        READY   STATUS    RESTARTS   AGE
helloweb-699c8747f8-9ljdb   1/1     Running   0          53m
helloweb-699c8747f8-gd6pm   1/1     Running   0          54m
helloweb-6b9678d59f-5p8c5   0/1     Pending   0          9s
helloweb-6b9678d59f-ctbl2   1/1     Running   0          11s
helloweb-6b9678d59f-djxgl   0/1     Pending   0          11s
helloweb-6b9678d59f-wc4s9   1/1     Running   0          11s
helloweb-6b9678d59f-xqqd8   0/1     Pending   0          9s
```

Check the reason for pending
```bash 
kubectl describe pod helloweb-6b9678d59f-5p8c5
```

```text
...
Events:
  Type     Reason            Age                From                Message
  ----     ------            ----               ----                -------
  Warning  FailedScheduling  28s (x4 over 35s)  default-scheduler   0/6 nodes are available: 3 Insufficient cpu, 3 node(s) had taint {node-role.kubernetes.io/master: }, that the pod didn't tolerate.
```

Ok, so why no autoscaling happened? Check the logs of `cluster-autoscaler` pod in the `kube-system` namespace:

```bash
kubectl logs -n kube-system -f cluster-autoscaler-xx-xx
```
or
```bash
klog -f   # select cluster-autoscaler-xx-xx pod
```

```text
I0520 14:30:21.735182       1 scale_up.go:453] No expansion options
I0520 14:30:31.754110       1 klogx.go:86] Pod app-ext/helloweb-6b9678d59f-fwbdj is unschedulable
I0520 14:30:31.754170       1 klogx.go:86] Pod app-ext/helloweb-6b9678d59f-f8h4n is unschedulable
I0520 14:30:31.754179       1 klogx.go:86] Pod app-ext/helloweb-6b9678d59f-frjhv is unschedulable
I0520 14:30:31.755596       1 scale_up.go:453] No expansion options
```

It seems, there is no option for scale right now. To fix this we need to set the following annotations to the machine deployments:

```yaml
kind: MachineDeployment
metadata:
  annotations:
    cluster.k8s.io/cluster-api-autoscaler-node-group-min-size: "1"
    cluster.k8s.io/cluster-api-autoscaler-node-group-max-size: "5"
```

So update annotations of each machine deployment:

```bash
kubectl annotate --overwrite md k1-pool-az-a "cluster.k8s.io/cluster-api-autoscaler-node-group-max-size"="5" -n kube-system 
kubectl annotate --overwrite md k1-pool-az-b "cluster.k8s.io/cluster-api-autoscaler-node-group-max-size"="5" -n kube-system 
kubectl annotate --overwrite md k1-pool-az-c "cluster.k8s.io/cluster-api-autoscaler-node-group-max-size"="5" -n kube-system 
```

Check now the cluster autoscaler logs, the change get notified, and a scale up get triggered from `Final scale-up plan: [{MachineDeployment/kube-system/k1-pool-az-c 1->4 (max: 5)}]`

```bash
kubectl logs -n kube-system cluster-autoscaler-xx-xx
```

```text
I0520 14:35:33.624269       1 scale_up.go:453] No expansion options
W0520 14:35:44.708220       1 clusterstate.go:432] AcceptableRanges have not been populated yet. Skip checking
W0520 14:35:44.708247       1 clusterstate.go:432] AcceptableRanges have not been populated yet. Skip checking
W0520 14:35:44.708254       1 clusterstate.go:432] AcceptableRanges have not been populated yet. Skip checking
W0520 14:35:45.306517       1 clusterapi_controller.go:455] Machine "k1-pool-az-c-576dff79fd-v4hx4" has no providerID
W0520 14:35:45.306517       1 clusterapi_controller.go:455] Machine "k1-pool-az-a-86b6dcbfb4-vg8q8" has no providerID
W0520 14:35:45.306992       1 clusterapi_controller.go:455] Machine "k1-pool-az-b-864f98574f-mb97d" has no providerID
I0520 14:35:49.506482       1 klogx.go:86] Pod app-ext/helloweb-6b9678d59f-f8h4n is unschedulable
I0520 14:35:49.506514       1 klogx.go:86] Pod app-ext/helloweb-6b9678d59f-frjhv is unschedulable
I0520 14:35:49.506521       1 klogx.go:86] Pod app-ext/helloweb-6b9678d59f-fwbdj is unschedulable
I0520 14:35:51.907554       1 scale_up.go:468] Best option to resize: MachineDeployment/kube-system/k1-pool-az-c
I0520 14:35:51.907590       1 scale_up.go:472] Estimated 3 nodes needed in MachineDeployment/kube-system/k1-pool-az-c
I0520 14:35:52.106526       1 scale_up.go:586] Final scale-up plan: [{MachineDeployment/kube-system/k1-pool-az-c 1->4 (max: 5)}]
I0520 14:35:52.106572       1 scale_up.go:675] Scale-up: setting group MachineDeployment/kube-system/k1-pool-az-c size to 4
I0520 14:36:01.401730       1 node_instances_cache.go:156] Start refreshing cloud provider node instances cache
W0520 14:36:01.424325       1 clusterapi_controller.go:455] Machine "k1-pool-az-c-576dff79fd-v4hx4" has no providerID
W0520 14:36:01.424465       1 clusterapi_controller.go:455] Machine "k1-pool-az-c-576dff79fd-mgnnc" has no providerID
W0520 14:36:01.424511       1 clusterapi_controller.go:455] Machine "k1-pool-az-c-576dff79fd-sssq2" has no providerID
W0520 14:36:01.424534       1 clusterapi_controller.go:455] Machine "k1-pool-az-c-576dff79fd-l8lkb" has no providerID
W0520 14:36:01.425250       1 clusterapi_controller.go:455] Machine "k1-pool-az-a-86b6dcbfb4-vg8q8" has no providerID
W0520 14:36:01.425499       1 clusterapi_controller.go:455] Machine "k1-pool-az-b-864f98574f-mb97d" has no providerID
I0520 14:36:01.425578       1 node_instances_cache.go:168] Refresh cloud provider node instances cache finished, refresh took 23.25146ms
W0520 14:36:06.730359       1 clusterapi_controller.go:455] Machine "k1-pool-az-c-576dff79fd-l8lkb" has no providerID
W0520 14:36:06.730389       1 clusterapi_controller.go:455] Machine "k1-pool-az-c-576dff79fd-v4hx4" has no providerID
W0520 14:36:06.730713       1 clusterapi_controller.go:455] Machine "k1-pool-az-c-576dff79fd-mgnnc" has no providerID
W0520 14:36:06.730734       1 clusterapi_controller.go:455] Machine "k1-pool-az-c-576dff79fd-sssq2" has no providerID
I0520 14:36:10.930498       1 filter_out_schedulable.go:79] Schedulable pods present
I0520 14:36:10.930549       1 static_autoscaler.go:401] No unschedulable pods
I0520 14:36:12.130623       1 pre_filtering_processor.go:66] Skipping k1-pool-az-b-864f98574f-mb97d - node group min size reached
I0520 14:36:12.130973       1 pre_filtering_processor.go:66] Skipping k1-pool-az-a-86b6dcbfb4-vg8q8 - node group min size reached
```

Now the `MachineDeployment` replica count get updated to e.g. `4` and new nodes will join the cluster after some minutes. Then the pods should be also get scheduled as running:

```bash
kubectl get md,ms,ma,node -A
```

```text
NAMESPACE     NAME                                            REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       KUBELET   AGE
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-a   5          5                    gce        ubuntu   1.32.4    5h
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-b   2          2                    gce        ubuntu   1.32.4    4h39m
kube-system   machinedeployment.cluster.k8s.io/k1-pool-az-c   1          1                    gce        ubuntu   1.32.4    4h39m

NAMESPACE     NAME                                                REPLICAS   AVAILABLE-REPLICAS   PROVIDER   OS       MACHINEDEPLOYMENT   KUBELET   AGE
kube-system   machineset.cluster.k8s.io/k1-pool-az-a-6dbdd9775b   5          5                    gce        ubuntu   k1-pool-az-a        1.32.4    19m
kube-system   machineset.cluster.k8s.io/k1-pool-az-a-7fb4567dbf   0                               gce        ubuntu   k1-pool-az-a        1.31.8    4h29m
kube-system   machineset.cluster.k8s.io/k1-pool-az-b-7d57bb75dd   0                               gce        ubuntu   k1-pool-az-b        1.31.8    4h27m
kube-system   machineset.cluster.k8s.io/k1-pool-az-b-b6cd6698f    2          2                    gce        ubuntu   k1-pool-az-b        1.32.4    19m
kube-system   machineset.cluster.k8s.io/k1-pool-az-c-7b7fd67fb7   0                               gce        ubuntu   k1-pool-az-c        1.31.8    4h27m
kube-system   machineset.cluster.k8s.io/k1-pool-az-c-95bf957fd    1          1                    gce        ubuntu   k1-pool-az-c        1.32.4    19m

NAMESPACE     NAME                                                   PROVIDER   OS       NODE                            KUBELET   ADDRESS          AGE
kube-system   machine.cluster.k8s.io/k1-pool-az-a-6dbdd9775b-dsq8k   gce        ubuntu   k1-pool-az-a-6dbdd9775b-dsq8k   1.32.4    34.34.126.230    4m14s
kube-system   machine.cluster.k8s.io/k1-pool-az-a-6dbdd9775b-f96ww   gce        ubuntu   k1-pool-az-a-6dbdd9775b-f96ww   1.32.4    34.141.237.8     4m14s
kube-system   machine.cluster.k8s.io/k1-pool-az-a-6dbdd9775b-gcbjw   gce        ubuntu   k1-pool-az-a-6dbdd9775b-gcbjw   1.32.4    34.90.33.196     4m14s
kube-system   machine.cluster.k8s.io/k1-pool-az-a-6dbdd9775b-k6gl4   gce        ubuntu   k1-pool-az-a-6dbdd9775b-k6gl4   1.32.4    34.90.198.72     4m14s
kube-system   machine.cluster.k8s.io/k1-pool-az-a-6dbdd9775b-rrwpv   gce        ubuntu   k1-pool-az-a-6dbdd9775b-rrwpv   1.32.4    34.141.235.231   19m
kube-system   machine.cluster.k8s.io/k1-pool-az-b-b6cd6698f-68cjk    gce        ubuntu   k1-pool-az-b-b6cd6698f-68cjk    1.32.4    34.32.151.16     3m52s
kube-system   machine.cluster.k8s.io/k1-pool-az-b-b6cd6698f-c96xz    gce        ubuntu   k1-pool-az-b-b6cd6698f-c96xz    1.32.4    34.90.223.239    19m
kube-system   machine.cluster.k8s.io/k1-pool-az-c-95bf957fd-t4jv5    gce        ubuntu   k1-pool-az-c-95bf957fd-t4jv5    1.32.4    34.34.76.171     19m

NAMESPACE   NAME                                 STATUS   ROLES           AGE     VERSION
            node/k1-control-plane-1              Ready    control-plane   5h4m    v1.32.4
            node/k1-control-plane-2              Ready    control-plane   4h54m   v1.32.4
            node/k1-control-plane-3              Ready    control-plane   4h54m   v1.32.4
            node/k1-pool-az-a-6dbdd9775b-dsq8k   Ready    <none>          110s    v1.32.4
            node/k1-pool-az-a-6dbdd9775b-f96ww   Ready    <none>          51s     v1.32.4
            node/k1-pool-az-a-6dbdd9775b-gcbjw   Ready    <none>          49s     v1.32.4
            node/k1-pool-az-a-6dbdd9775b-k6gl4   Ready    <none>          81s     v1.32.4
            node/k1-pool-az-a-6dbdd9775b-rrwpv   Ready    <none>          15m     v1.32.4
            node/k1-pool-az-b-b6cd6698f-68cjk    Ready    <none>          20s     v1.32.4
            node/k1-pool-az-b-b6cd6698f-c96xz    Ready    <none>          16m     v1.32.4
            node/k1-pool-az-c-95bf957fd-t4jv5    Ready    <none>          16m     v1.32.4
```

You can also check that all application pods are Running.

```bash
kubectl get pod -n app-ext
```

```text
NAME                        READY   STATUS    RESTARTS   AGE
helloweb-6b9678d59f-f8h4n   1/1     Running   0          12m
helloweb-6b9678d59f-frjhv   1/1     Running   0          12m
helloweb-6b9678d59f-fwbdj   1/1     Running   0          12m
helloweb-6b9678d59f-fxjc8   1/1     Running   0          12m
helloweb-6b9678d59f-lk57z   1/1     Running   0          12m
```

Jump > [**Home**](../README.md) | Previous > [**KubeOne and Kubernetes Upgrade**](../11_kubeone_upgrade/README.md) | Next > [**Bonus**](../90_bonus/README.md)