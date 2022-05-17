# KubeOne Addons

In this chapter, we will create a [KubeOne addon](https://docs.kubermatic.com/kubeone/master/guides/addons/) on the creation of:
 1. Storage Class
 2. [Restic backup addon](https://docs.kubermatic.com/kubeone/master/examples/addons_backup) adjusted for GCP 

Addons are a mechanism used to deploy Kubernetes resources after provisioning the cluster. Addons allow operators to use KubeOne to deploy various components such as CNI and CCM, and various stacks such as logging and monitoring, backups and recovery, log rotating. Addons can be used also for any other extension of your Kubernetes cluster, e.g:
 - Storage Class (CSI)
 - Ingress Controllers
 - LoadBalancers (e.g. [MetalLB](https://metallb.universe.tf/), see as ref. [KKP - MetalLB Addon](https://github.com/kubermatic/community-components/tree/master/kubermatic-addons/custom-addon/metallb))

This document explains how to use addons in your workflow. If you want to learn more about how addons are implemented, you can check the [documentation](https://docs.kubermatic.com/kubeone/master/guides/addons/) for more details.

>**HINT:** Some Kubermatic KKP Addons will potentially work as well for KubeOne, you only need to ensure that executed Templating matches, see [KubeOne Addon Templating](https://docs.kubermatic.com/kubeone/master/guides/addons/#templating) vs. [KKP Addon - Manifest Templating](https://docs.kubermatic.com/kubermatic/master/guides/addons/#manifest-templating).

Some "raw" Addons can be found here:
- [KKP Default Addons](https://github.com/kubermatic/kubermatic/tree/master/addons)
- [KKP Community Addons](https://github.com/kubermatic/community-components/tree/master/kubermatic-addons/custom-addon)

## 1. GCE Storage Class Addon

If you take a look in your current cluster, currently no storage class is applied. If you create a new Persistent Volume Claim, no storage get applied.

```bash
cd $TRAINING_DIR
kubectl get sc
```

```text
No resources found
```

Let's now deploy a pod with some PVC:

```bash
kubectl create ns sc-test
kubectl config set-context --current --namespace=sc-test
```
or
```bash
kcns sc-test
```

Create a PVC
```bash
kubectl apply -f 10_addons-sc-and-restic-etcd-backup/pvc.test.yaml
```

Check the pending pod,pvc,pv state
```bash
kubectl get pod,pvc,pv
```

```text
NAME         READY   STATUS    RESTARTS   AGE
pod/my-pod   0/1     Pending   0          29s

NAME                           STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/my-pvc   Pending                                                     29s
```

If you now describe the PVC `my-pvc` you will see the error:

```bash
kubectl describe pvc my-pvc 
```

```text
Name:          my-pvc
Namespace:     sc-test
StorageClass:  
Status:        Pending
Volume:        
Labels:        <none>
Annotations:   <none>
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      
Access Modes:  
VolumeMode:    Filesystem
Used By:       my-pod
Events:
  Type    Reason         Age                 From                         Message
  ----    ------         ----                ----                         -------
  Normal  FailedBinding  14s (x8 over 104s)  persistentvolume-controller  no persistent volumes available for this claim and no storage class is set
```

As the error tells you `no storage class is set`, we need to configure a storage class. To get familiar with the storage class concept, take a look at the official [Kubernetes Documentation - Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/).

As a reference, we could take a look into the [KKP Addon > Default Storage Class](https://github.com/kubermatic/kubermatic/blob/master/addons/default-storage-class/storage-class.yaml) and search GCP one.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.beta.kubernetes.io/is-default-class: "true"
  labels:
    kubernetes.io/cluster-service: "true"
  name: standard
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
```

This config seems to look fine for our KubeOne cluster as well. As the cloud controller manager is taking care about the communication to GCE, we can directly use this storage class. For more information see [Storage Class - GCE PD](https://kubernetes.io/docs/concepts/storage/storage-classes/#gce-pd). At this documentation page, you also find quite a good starting point for every other supported Kubernetes Storage Class.

Now let's create a new addon for our setup with the above Storage Class.

```bash
cd $TRAINING_DIR/src/gce
```

First create the storage class manifest fest file
```bash
mkdir -p "addons"
vim addons/sc.yaml
```
>Paste here the storage class object from above

Now configure kubeone.yaml
```bash
vim kubeone.yaml
```
As we don't use the templating functions, we can enable the addon mechanism directly:
```yaml
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
#### <<<<< ADD
# Addons are Kubernetes manifests to be deployed after provisioning the cluster
addons:
  enable: true
  # In case when the relative path is provided, the path is relative
  # to the KubeOne configuration file.
  path: "./addons"
```

Save the change and basically you're done. The last missing step is to apply the change by kubeone:

```bash
kubeone apply -t ./tf-infra --verbose
```

You see now that the action output contains `~ ensure addons`:

```text
The following actions will be taken: 
Run with --verbose flag for more information.

	~ ensure nodelocaldns
	~ ensure CNI
	~ ensure addons
	~ ensure credential
	~ ensure machine-controller

Do you want to proceed (yes/no): yes
```

If you now inspect your cluster, you see the storage class has been applied and is ready to use. To ensure KubeOne is "aware" of the addon, a label `kubeone.io/addon: ""` is added:

```bash
kubectl get sc standard -o yaml
```

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"storage.k8s.io/v1","kind":"StorageClass","metadata":{"annotations":{"storageclass.beta.kubernetes.io/is-default-class":"true"},"labels":{"kubeone.io/addon":"","kubernetes.io/cluster-service":"true"},"name":"standard"},"parameters":{"type":"pd-ssd"},"provisioner":"kubernetes.io/gce-pd"}
    storageclass.beta.kubernetes.io/is-default-class: "true"
  creationTimestamp: "2021-05-18T17:03:09Z"
  labels:
    kubeone.io/addon: ""
    kubernetes.io/cluster-service: "true"
  name: standard
  resourceVersion: "585068"
  selfLink: /apis/storage.k8s.io/v1/storageclasses/standard
  uid: d30c0db0-fe1e-44b0-adcf-988e7a10c346
parameters:
  type: pd-ssd
provisioner: kubernetes.io/gce-pd
reclaimPolicy: Delete
volumeBindingMode: Immediate
```

Now let's see what happens with our example pod:

```bash
kubectl get pod,pvc,pv
```

```text
NAME         READY   STATUS    RESTARTS   AGE
pod/my-pod   0/1     Pending   0          21m

NAME                           STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/my-pvc   Pending                                                     21m
```

So the PVC is still pending! Why? The default storage class has not been set due to the time when we created the PVC, so that's why we need to do one of the two options:
 - Define the storage class `standard` in the PVC `kubectl edit pvc my-pvc`
 - (or) Recreate the PVC `kubectl replace --force -f ../../10_addons-sc-and-restic-etcd-backup/pvc.test.yaml`

Afterwards you see, that we now have a running pod and a bound PVC

```bash
kubectl get pod,pvc,pv
```

```text
NAME         READY   STATUS    RESTARTS   AGE
pod/my-pod   0/1     Running   0          6s

NAME                           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/my-pvc   Bound    pvc-c3979b78-4898-4576-be9b-047c31abc11c   1Gi        RWO            standard       6s

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM            STORAGECLASS   REASON   AGE
persistentvolume/pvc-c3979b78-4898-4576-be9b-047c31abc11c   1Gi        RWO            Delete           Bound    sc-test/my-pvc   standard                4s
```

# 2. Restic Backup for etcd Snapshots

Next we want to create a dedicated backup for our etcd database in an automated way. So as reference, KubeOne already have a default addon for storing the etcd snapshots at a S3 Location, see [Restic backup addon](https://docs.kubermatic.com/kubeone/master/examples/addons_backup). Now we want to adjust it to use our GCP Storage Bucket.

The chapter folder already contains and template what have been adjusted to use GS bucket. If you compare the both files [`template.backups-restic.yaml`](./template.backups-restic.yaml) and [`backups-restic.yaml`](https://github.com/kubermatic/kubeone/raw/master/addons/backups-restic/backups-restic.yaml), you see that only minor adjustment has been needed. For more details how to configure Restic, see the [Restic Documentation - Preparing a new repository - Google Cloud Storage](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#google-cloud-storage).
![restic_yaml_diff_s3_vs_gs](../.images/restic_yaml_diff_s3_vs_gs.png)

To prevent to manage Google Service Account credential secret, we can use the [KubeOne Addon Templating](https://docs.kubermatic.com/kubeone/master/guides/addons/#templating) and render the `.Credentials object` into a base64 encoded secret. At the KubeOne Go code, we can see the data constant what get used for credential rendering [`pkg/credentials/credentials.go`](https://github.com/kubermatic/kubeone/blob/c824810769d4ce55b3cfdc560b46b6563c8c509e/pkg/credentials/credentials.go). In our case, we use the `.Credentials.GOOGLE_CREDENTIALS` what is wrapped into the [`b64enc` sprig function](http://masterminds.github.io/sprig/encoding.html).

Now let's copy the template and adjust the needed `<<TODO_xxxx>>` parameters to our lab environment:

```bash
cd $TRAINING_DIR/src/gce

cp ../../10_addons-sc-and-restic-etcd-backup/template.backups-restic.yaml addons/gs.backups-restic.yaml
vim addons/gs.backups-restic.yaml
```

Adjust now the `<<TODO_xxxx>>` parameter:
- `<<TODO_RESTIC_PASSWORD>>`: some random string value, e.g. create a random string by: `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c24`
- `<<TODO_GS_BUCKET_NAME>>`: you present gs bucket, check `gsutil ls`
- `<<TODO_BACKUP_FOLDER_NAME>>`: custom folder as backup location (get created), e.g. `etcd-snapshot-backup`
- `<<TODO_GOOGLE_PROJECT_ID>>`: your google project id, check `gcloud projects list`

Afterwards ensure no `TODO` is left and apply the new addon:

```bash
grep TODO addons/gs.backups-restic.yaml

kubeone apply -t ./tf-infra --verbose
```

You see the adjustments of the backup location, isn't hard and could be done a few changes of the restic environment variables. So let's now test, if we could see a cronjob and execute a test backup.

```bash
kubectl get cronjobs -n kube-system
```

```text
NAME             SCHEDULE     SUSPEND   ACTIVE   LAST SCHEDULE   AGE
etcd-gs-backup   @every 30m   False     0        <none>          9s
```
>As you see, every `30m` will automatic backup job be scheduled now.

To test now the backup create, we create a manual test job:
```bash
kubectl config set-context --current --namespace=kube-system
```
or
```bash
kcns kube-system
```

Create a job from the cronjob
```bash
kubectl create job --from cronjob/etcd-gs-backup test-etcd-backup
```

Check, if job got created and pod is running
```bash
kubectl get job,pod | grep test
```

```text
job.batch/test-etcd-backup   1/1           18s        79s
pod/test-etcd-backup-gg8gw                        0/1     Completed   0          79s
```

Check the logs of the backup pod
```bash
kubectl logs test-etcd-backup-gg8gw
```

See, if the bucket contains restic data
```
gsutil ls -r gs://k1-backup-bucket-student-XX/etcd-snapshot-backup
```
Alright, seems everything looks fine, and our cluster has automatic backup configured.

Jump > [**Home**](../README.md) | Previous > [**Velero Backup Process**](../09_backup_velero/README.md) | Next > [**KubeOne and Kubernetes Upgrade**](../11_kubeone_upgrade/README.md)