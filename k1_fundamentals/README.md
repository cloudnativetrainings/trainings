# KubeOne Training Lab

**Introduction:** The purpose of this write-up is to document the process of setting up a KubeOne Kubernetes cluster, this cluster will eventually be used to install a Kubermatic cluster later.

**Pre-requisite:** It is assumed that the reader is fairly familiar with how kubernetes and Linux works, references for additional information will also be included.

**Deliverables:**

* Deploy a KubeOne kubernetes cluster on GCP
* Demonstrate scaling up/down of worker nodes using the Machine controller.
* Install an ingress controller (Nginx)
* Install CertManager to cater for SSL certificate management
* Install a demo application to test everything
* Upgrade the Kubernetes cluster

## Initial KubeOne Setup

KubeOne is a Kubernetes installer project by Kubermatic, it supports creating a Kubernetes cluster across major public cloud providers (GCP, AWS, Azure, Packet) and baremetal platforms (vSphere, Open Stack).

For this write-up, we will be using Google cloud platform to install a KubeOne cluster which will later be used for the Kubermatic installation.

Setting up KubeOne is mainly a two step process:

* First step is to create an infrastructure using Terraform (there are sample Terraform templates in the KubeOne repo), this will create all the needed infrastructure nodes like the compute, storage volumes, load balancer for the control plane etc. At the end a tf.json file will be created from the output. This json file consists of all the details of the infrastructure that was created by Terraform and it will be used by KubeOne to install the actual Kubernetes cluster.
* Second step is to install the Kubernetes cluster using the tf.json (Terraform json) file as indicated above. In addition to the tf.json file KubeOne also requires another configuration file (written in yaml). This configuration file will give KubeOne the necessary Kubernetes information that is needed to create the cluster, this includes things like the Kubernetes version that is to be installed, the cloud provider (in this case will be gcp) etc.

To discover more details about KubeOne, take a look at our latest [KubeOne - Docs](https://docs.kubermatic.com/kubeone/master/).

Through the journey of the training, we are now starting with the following step: [00_setup](./00_setup/README.md)

For more commercial information see [Kubermatic KubeOne](https://www.kubermatic.com/products/kubeone/).