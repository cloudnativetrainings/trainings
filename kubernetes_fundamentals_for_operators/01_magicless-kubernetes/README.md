# Magicless Kubernetes

In this lab you will setup a Kubernetes Cluster from scratch, without any help from tools like kubeadm, kubeone or others. 

## Google Cloud Setup

For having a convinient way of working in Google Cloud.

```bash
make setup
source ~/.trainingrc
make verify
```

Additonally please deactivate Tmux in the Google Cloud Shell.

## Preps

* Setting up the Network
* Create the VMs
* Create the needed Certs
* Create the needed Kubeconfigs
* Create the Encryption Config

## Create the Controlplane

* Copy the needed files to the master nodes
* Switch to master nodes via Tmux
* Create Etcd Cluster
* Preps for starting Controlplane Components
* Create the kube-apiserver services
* Create the kube-controller-manager services
* Create the kube-scheduler services
* Ensure communication between kube-apiserver services and kubelets

## Create the worker nodes

* Copy the needed files to the worker nodes
* Switch to worker nodes via Tmux
* Create the containerd services
* Create the kubelet services
* Create the kube-proxy services
* Configure CNI-Plugins
* Ensure bridge CNI-Plugin is working

## Test your Kubernetes Cluster

* Pods
* Secrets
