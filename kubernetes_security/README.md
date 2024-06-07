# Kubernetes Fundamentals

## Setup Training Environment

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com) via web browser.
2. Clone the Kubermatic trainings git repository:`git clone https://github.com/kubermatic-labs/trainings.git`
3. Navigate to Kubernetes Fundamentals training folder to get started `cd trainings/kubernetes_security/`

### Create Training VM

Open a new terminal tab.

> Ensure that the project is properly set.

```bash
# change directory
cd 00_setup/

# create the VM
make setup
```

## Verify Training Environment

> Note that the VM will get setup via Cloud-Init which will take ~ 5 minutes for setting up everything.

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

# verify all tools got installed properly
make verify
```

## Teardown Training Environment

```bash
# switch to the google cloud shell
exit

# destroy environment
make destroy
```
