# Setup

## Create Training VM

Open a new terminal tab with the project properly set.

```bash
# clone the git repo
git clone https://github.com/kubermatic-labs/trainings

# change directory
cd trainings/k8s_security/00_setup/

# create the VM
make create
```

Note that the VM will get setup via Cloud-Init which will take ~ 5 minutes for setting up everything.

## Verify setup

```bash
# ssh into the new VM
gcloud compute ssh root@kubernetes-security --zone europe-west3-a

# verify cloud-init finished successfully
cat /var/log/cloud-init-output.log | grep "CloudInit Finished Successfully"

# verify single node Kubernetes cluster
kubectl get nodes

# verify bash completion is in place
kubectl get node <TAB>

# verify that a single pod is running in the default namespace
kubectl get pods
```