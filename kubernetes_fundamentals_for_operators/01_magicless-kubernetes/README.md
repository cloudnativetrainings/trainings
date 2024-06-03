# Magicless Kubernetes

In this lab you will setup a Kubernetes Cluster from scratch, without any help from tools like kubeadm, kubeone or others.

## Preparations

### Google Cloud Setup

For having a convinient way of working in Google Cloud.

```bash
make setup
source ~/.trainingrc
make verify
```

### Tmux

Additonally please deactivate Tmux in the Google Cloud Shell.

## Setting up the HA Cluster

You will create a Kubernetes Cluster with 3 ControlPlane Nodes and 3 Worker Nodes.

### Infrastructure

Create the Network and VMs.

#### Setup Network

Create the

* Network and Subnet where the VMs will be placed in
* Firewall Rules, for
    * internal communication
    * access to the API-Server
* Static IP Address for the LoadBalancer in front of the API-Server instances.

#### Create the VMs

Create the VMs for the HA Cluster
* 3 VMs for the ControlPlane
* 3 VMs for the Worker Nodes

### Sensitive Data

Create the needed certs and config files for encrypted communication and storage.

#### Create the needed Certs

Create the CA and the certificates for encrypted communication between the Kubernetes Components.

#### Create the needed Kubeconfigs

Make use of the certificates to create the kubeconfigs for encrypted communication between the Kubernetes Components.

#### Create the Encryption Config

Create a Kubernetes EncryptionConfig which ensures encrypted secrets in etcd.

### Create the Controlplane

Create the 3 ControlPlane Nodes.

#### Copy the needed files to the master nodes

Copy the needed configs and sensitive data to the 3 VM instances.

#### Switch to master nodes via Tmux

Make use of Tmux for making changes on the 3 VMs

#### Create Etcd Cluster

Install and start the etcd cluster.

#### Preps for starting Controlplane Components

Download ControlPlane binaries and install configs and certs to their proper location.

#### Create the kube-apiserver services

Install and start the kube-apiserver.

#### Create the kube-controller-manager services

Install and start the kube-controller-manager.

#### Create the kube-scheduler services

Install and start the kube-scheduler.

#### Ensure communication between kube-apiserver services and kubelets

Configure Kubernetes for enabling communication from the api-server to the kubelets via RBAC.

### Create the worker nodes

Create 3 the Worker Nodes.

#### Copy the needed files to the worker nodes

Copy the needed configs and sensitive data to the 3 VM instances.

#### Switch to worker nodes via Tmux

Make use of Tmux for making changes on the 3 VMs

#### Create the containerd services

Install and start the containerd.

#### Create the kubelet services

Install and start the kubelets.

#### Create the kube-proxy services

Install and start the kube-proxys.

#### Configure CNI-Plugins

Install the bridge CNI plugin and install config files to the proper location.

#### Ensure bridge CNI-Plugin is working

Due to the use of the bridge CNI plugin we have to create routes between the worker nodes.

### Test your Kubernetes Cluster

Verify everything is working.

#### Pods

Test if workloads can be deployed and can be reached afterwards via curl.

#### Secrets

Test if secrets are encrypted in etcd.
