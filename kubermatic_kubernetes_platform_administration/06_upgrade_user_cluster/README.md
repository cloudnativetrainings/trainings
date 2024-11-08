# Upgrade User Clusters

Check on an existing cluster the upgrade possibilities

![](../img/upgrade_user_clusters.png)

## Upgrade of User Cluster with UI

Within the UI upgrade your cluster to version `1.29.1`. Also check the checkbox `Upgrade Machine Deployments`.

The control plane of your user cluster will be upgraded very fast, due to it is only about starting new containers. The worker nodes will need about ~ 5 minutes to get updated, due to this is about starting new VMs.

Take also a look at the installed applications. For sure they are still running.

## Manage the available Kubernetes versions

Add the following to the file `kubermatic.yaml` in the `spec` section (mind the proper indent):

```yaml
versions:
  versions:
    - v1.29.1
    - v1.29.4
  default: "1.29.1"
```

Apply the updated Kubermatic configuration

```bash
kubectl apply -f ~/kkp/kubermatic.yaml
```

Afterwards you can verify the choosable Kubernetes Versions for your User Cluster also in the KKP UI.

## Upgrade of User Cluster via Terminal

Now you will update your User Cluster via terminal. Additionally you will verify the availability of our echoserver application.

```bash
# get the external ip address of your ingress stack in your user cluster
kubectl --kubeconfig=~/kubeconfig-admin-XXXXX -n ingress-nginx get svc

# open a new terminal in the google cloud shell 
while true; do curl http://<EXTERNAL-IP>:80/ | jq; sleep 10s; done;
```

### Upgrade the Control Plane

Change the field `spec.version` of the User Cluster to `1.29.4`.

```bash
kubectl edit cluster XXXXX

# observe the application is still responding in the second terminal
# the upgrade of the control plane of the user cluster does not affect the running containers on the worker nodes
```

### Upgrade the Worker Nodes

Change the version of the User Clusters MachineDeployment via the following. Change the version of the field `spec.template.spec.versions.kubelet` to `1.29.4`.

```bash
kubectl --kubeconfig ~/kubeconfig-admin-XXXXX -n kube-system edit md XXXXX 

# observe the nodes getting upgraded
watch -n 1 kubectl get nodes

# observe the application is still responding in the second terminal
# note that the application may will be down for a short period of time, but this is an application problem (the application is scaled to 1 and may have no proper probes set)
```
