# Create an GKE cluster

## Authenticate and Basic Config

1. Open a cloud shell for your project: [ssh.cloud.google.com/cloudshell](https://ssh.cloud.google.com/cloudshell)

***NOTE:*** If you want to use your environment install the `gcloud` CLI - [Installing Google Cloud SDK](https://cloud.google.com/sdk/install) - and authenticate with your given credentials:
```bash
gcloud auth login
```

2. Ensure you are authenticated with your `gcloud` CLI and list our GCP projects
```bash
gcloud projects list
```
3. Find out your nearest [GCP Location](https://cloud.google.com/compute/docs/regions-zones/#locations) and set some defaults:
```bash
gcloud config set compute/zone us-central1-c
gcloud config set compute/region us-central1
gcloud config set gcloud config set project student-XX-xxx 

```
4. Create a cluster with 2 nodes 
```bash
gcloud container clusters create studentXXcluster \
      --num-nodes 2 \
      --scopes cloud-platform
```

5. Ensure you you can access your cluster by using `kubectl` and see two healthy nodes:
```bash
kubectl get nodes
NAME                                              STATUS   ROLES    AGE     VERSION
gke-student00cluster-default-pool-6347c95f-0jxk   Ready    <none>   2m      v1.14.8-gke.12
gke-student00cluster-default-pool-6347c95f-90mn   Ready    <none>   3m      v1.14.8-gke.12
```
***NOTE:*** If you you get the error message `The connection to the server localhost:8080 was refused - did you specify the right host or port?` you probably are note authenticate to your Kubernetes cluster - please execute:
```bash
gcloud container clusters get-credentials studentXXcluster
```

## Allow NodePort range

A common way for access applications in Kubernetes is to use [Service - Type NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport). This service type opens random ports on every node in the range `30000-32767`. On GKE clusters this port ranged is blocked by the [GCP VPC Firewall](https://console.cloud.google.com/networking/firewalls/list). To open the range in firewall we execute the following command:

```bash
gcloud compute firewall-rules create enable-node-port-range-rule --allow tcp:30000-32767
```

***WARNING:*** This lowers the security level of an Kubernetes clusters, so this should not be used for productive clusters!
