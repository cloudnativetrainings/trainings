# KubeOne Cluster setup

KKP installs on pre-existing Kubernetes cluster. KubeOne is the open-source solution from Kubermatic to manage the entire lifecycle of the Kubernetes cluster, including installing and provisioning, upgrading, repairing, and deprovisioning using declarative way.

## Prepare Secrets

To begin with, we need a secret to authenticate with GCP. Steps are quite similar as described in [KubeOne Fundamentals Training](../../k1_fundamentals):

### Option-1 Copy existing secrets from K1 Fundamentals Training

If you did the k1 fundamentals labs, feel free to copy the needed secrets to your KKP secrets folder.

``` bash
cp -r $TRAINING_DIR/../k1_fundamentals/.secrets $TRAINING_DIR
```

>Note - If you did the K1 fundamentals labs, please ensure that you destroyed the former KubeOne Cluster and DNS records with the help of [cluster cleanup](../../k1_fundamentals/99_cluster-cleanup-or-pause)!

### Option-2 Create fresh credentials

Ensure that you execute below commands inside of the tooling container
```bash
cd $TRAINING_DIR
mkdir ./.secrets && cd ./.secrets
```

Ensure you are connected and get your Project ID
```bash
gcloud projects list
```

Create new service account
```bash
gcloud iam service-accounts create k1-service-account
```

Get your service account id
```bash
gcloud iam service-accounts list
```

Configure your IDs
```bash
export GCP_PROJECT_ID=__YOUR_GCP_PROJECT_ID__                  # student-XX-xxxx
export GCP_SERVICE_ACCOUNT_ID=__YOUR_GCP_SERVICE_ACCOUNT_ID__  # k1-service-account@student-XX-xxxx.iam.gserviceaccount.com 
```

Create policy binding
```bash
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/compute.admin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/iam.serviceAccountUser' 
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/viewer'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/storage.admin'
```

Create a new json key for your service account
```bash
gcloud iam service-accounts keys create --iam-account $GCP_SERVICE_ACCOUNT_ID k8c-cluster-provisioner-sa-key.json
```

Create SSH keys for nodes
```bash
ssh-keygen -f id_rsa
```

Check if content looks similar
```bash
ls -l
```

```text
-rw-------  1 kubermatic root 2610 May 27 21:23 id_rsa
-rw-r--r--  1 kubermatic root  577 May 27 21:23 id_rsa.pub
-rw-------  1 kubermatic root 2333 May 27 21:23 k8c-cluster-provisioner-sa-key.json
```

## Create Master Cluster

For simplicity of training, we have the predefined manifests at [`./kkp-master.template`](./kkp-master.template), refer below notes:

- Master Control Plan count is `1`, for production **HA control plan** at least `3` masters are recommended! *For the training purpose, we reduce some costs and only hold 1 master VM*
- Worker Nodes are using Autoscaler settings what are more reactive as it should be used in production.
- Worker Node OS doesn't get updated on the startup (speed up at scaling)

Run the following steps to provision the KubeOne cluster:

```bash
cd $TRAINING_DIR
cp -r 01-kubeone-cluster-setup/kkp-master.template src/kkp-master

export GCP_PROJECT_ID=__YOUR_GCP_PROJECT_ID__                  # student-XX-xxxx
```

Replace TODO-YOUR-GCP-PROJECT-ID with your project id. 
```bash
cd $TRAINING_DIR/src/kkp-master
find . -type f -exec sed -i 's/TODO-YOUR-GCP-PROJECT-ID/'"$GCP_PROJECT_ID"'/g' {} +
```

Start SSH agent and add id_rsa
>Update the SSH private `ssh_private_key_file` and public key `ssh_public_key_file` absolute path in `tf-infra/terraform.tfvars`. 
```bash
eval `ssh-agent`
ssh-add $TRAINING_DIR/.secrets/id_rsa
```

Deploy K1 cluster
```bash
make k1-tf-apply k1-apply
```

After everything is provisioned, check if nodes will get healthy:

```bash
export KUBECONFIG=`pwd`/kkp-master-kubeconfig
watch kubectl get machinedeployments.cluster.k8s.io,machinesets,machine,nodes -A
```

Jump > [Home](../README.md) | Previous > [Prepare Training Lab](../00-prepare-training-lab/README.md) | Next > [KKP Master Setup](../02-kkp-master-setup/README.md)