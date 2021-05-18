
# Velero Backup Process

The tool we are going to use for this purpose is [Velero](https://github.com/heptio/velero).

## Install Velero
`velero` should be included in your kubeone tooling container if not, see [Velero Basic Install](https://velero.io/docs/main/basic-install/). We will now create a backup into a GCP bucket, for more details see the Velero GCP guide [github.com/vmware-tanzu/velero-plugin-for-gcp](https://github.com/vmware-tanzu/velero-plugin-for-gcp)

### Create a Bucket

```
cd [training-repo]
cp ./09_backup_velero/gce/s3-bucket.tf ./src/gce/tf-infra/
cd ./src/gce/tf-infra

# verify creation
cat s3-bucket.tf
# create bucket
terraform apply
```
 A new bucket should be created! Now let's create a dedicated service account for it:

```bash
# create new service account
gcloud iam service-accounts create velero-service-account
# get your service account id
gcloud iam service-accounts list
# configure your IDs
export GCP_PROJECT_ID=__YOUR_GCP_PROJECT_ID__                  #student-XX-project
export GCP_VELERO_SERVICE_ACCOUNT_ID=__YOUR_GCP_SERVICE_ACCOUNT_ID__  # velero-service-account@student-XX.iam.gserviceaccount.com 

# create policy binding
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_VELERO_SERVICE_ACCOUNT_ID --role='roles/storage.admin'

# create a new json key for your service account
cd -
cd ./.secrects 
gcloud iam service-accounts keys create --iam-account $GCP_VELERO_SERVICE_ACCOUNT_ID credentials-velero.json
cd -
```

### Setup Velero
Due to them small nodes we need decrease a little the default resource CPU limits, otherwise we could use quickly the velero util to create a backup
```bash
velero install \
  --provider gcp \
  --plugins velero/velero-plugin-for-gcp:v1.2.0 \
  --bucket k1-backup-bucket \
  --velero-pod-cpu-request 250m \
  --secret-file .secrects/credentials-velero.json
```
To see if everything is OK you **HAVE TO** check the logs of the velero pod:
```
klog -f
# select velero pod
```
If you wonder where the GCP bucket credentials have been stored, take a look in the `cloud-credentials` secret
```
ksec
# select cloud-credentials in velero namespace
```
For later management of Velero, the backup storage location object is also worth to take a look:
```bash
kubectl get backupstoragelocations.velero.io -o yaml default | kexp

apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  labels:
    component: velero
  name: default
  namespace: velero
spec:
  default: true
  objectStorage:
    bucket: k1-backup-bucket
  provider: gcp
```

# Initiate a backup:
Starting ad-hoc backup it's easy to use the `velero` CLI:
```bash
velero backup create kubeone-demo-backup
```
Check the status of the backup process:
```bash
velero backup describe kubeone-demo-backup
# or
kubectl describe -n velero backups
```
```
Name:         kubeone-demo-backup
Namespace:    velero
Labels:       velero.io/storage-location=default
Annotations:  <none>

Phase:  Completed

Namespaces:
Included:  *
Excluded:  <none>

Resources:
Included:        *
Excluded:        <none>
Cluster-scoped:  auto

Label selector:  <none>

Storage Location:  default

Snapshot PVs:  auto

TTL:  720h0m0s

Hooks:  <none>

Backup Format Version:  1

Started:    2019-07-19 11:19:10 +0200 CEST
Completed:  2019-07-19 11:19:16 +0200 CEST

Expiration:  2019-08-18 11:19:10 +0200 CEST
```

To verify if backup files have been created
```bash
gsutil ls -r gs://k1-backup-bucket
```

Delete the ingress namespace and try to do a restore to test the backup that was created:

```bash
kubectl delete namespace ingress-nginx
```
```
namespace "ingress-nginx" deleted
```
```bash
kubectl get ns:
```
```
NAME              STATUS   AGE
cert-manager      Active   18h
default           Active   19h
kube-node-lease   Active   19h
kube-public       Active   19h
kube-system       Active   19h
velero            Active   20m
```
```bash
velero restore create --from-backup kubeone-demo-backup 
```
```
Restore request "kubeone-demo-backup-20190719112637" submitted successfully.
```
Run `velero restore describe kubeone-demo-backup-20190719112637` or `velero restore logs kubeone-demo-backup-20190719112637` for more details.

Check that the ingress-nginx namespace has been restored:

```bash
kubectl get ns
```
```
NAME              STATUS   AGE
cert-manager      Active   18h
default           Active   19h
ingress-nginx     Active   2m
kube-node-lease   Active   19h
kube-public       Active   19h
kube-system       Active   19h
velero            Active   23m
```

As you can see from the output above the ingress-nginx namespace has been restored (AGE 2mins). Let's check some of the objects in the namespace:

```bash
kubectl -n ingress-nginx get pod
```
```
NAME                                        READY   STATUS    RESTARTS   AGE
nginx-ingress-controller-86449c74bb-pwdlk   1/1     Running   0          5m
```
```
kubectl -n ingress-nginx get svc
```
```
NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP    PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.109.207.66    34.90.218.24   80:30075/TCP,443:32404/TCP   10h
ingress-nginx-controller-admission   ClusterIP      10.104.253.212   <none>         443/TCP                      10h

```
**IMPORTANT:** check if you still have the same external IP as in your Cloud DNS entry:
```bash
gcloud dns record-sets list --zone=$DNS_ZONE
```
**If this is not the case, go to [Google Cloud DNS](https://console.cloud.google.com/net-services/dns/zones) page and update the record!**

After the backup process, we can now proceed to attempt the upgrade

## Further Thoughts:
For productive usage, we recommend to manage Velero by a reproducible and git-ops based setup. For this e.g. KKP brings with his own preconfigured chart, take a look into the following resources:
* [KKP Velero Helm Chart](https://github.com/kubermatic/kubermatic/tree/master/charts/backup/velero)
* [Velero Backup Config API](https://velero.io/docs/v1.6/api-types/)

For a productive system a regular based scheduled backup is recommended. The backup strategy it-self depends on the workload:
- PV's backup?
- Replicas
- Permissions
- Location(s) and redundancy
