# Advanced Operations of Kubernetes with KubeOne

**Introduction:** The purpose of this write-up is to document the process of setting up a KubeOne Kubernetes cluster, this cluster will eventually be used to install a Kubermatic Kubernetes Platform later.

**Pre-requisite:** It is assumed that the reader is fairly familiar with how Kubernetes and Linux works, references for additional information will also be included.

**Deliverables:**
 * Deploy a KubeOne Kubernetes cluster on GCP
 * Demonstrate scaling up/down of worker nodes using the Machine controller.
 * Install an Ingress controller (Nginx)
 * Install CertManager to cater for SSL certificate management
 * Install a demo application to test everything
 * Upgrade the Kubernetes cluster

## Initial KubeOne Setup

KubeOne is a Kubernetes Conformance Certified installer project by Kubermatic, it helps to deploy and operate standalone Kubernetes cluster across major public cloud providers (GCP, AWS, Azure, Packet) and baremetal platforms (vSphere, Open Stack, Hetzner).

For this write-up, we will be using Google Cloud Platform to install a KubeOne cluster which will later be used for the Kubermatic Kubernetes Platform installation.

Setting up KubeOne is mainly a 2-step process:
 * First step: Create an infrastructure using Terraform (there are sample Terraform templates in the KubeOne repo), this will create all the needed infrastructure nodes like the compute, storage volumes, load balancer for the control plane, etc. At the end, a tf.json file will be created from the output. This json file consists of all the details of the infrastructure that was created by Terraform and it will be used by KubeOne to install the actual Kubernetes cluster.
 * Second step: Install the Kubernetes cluster using the tf.json (Terraform json) file as indicated above. In addition to the tf.json file, KubeOne also requires another configuration file (written in yaml). This configuration file will give KubeOne the necessary Kubernetes information that is needed to create the cluster, this includes things like the Kubernetes version that is to be installed, the cloud provider (in this case will be GCP), etc.

To discover more details about KubeOne, take a look at our latest [KubeOne - Docs](https://docs.kubermatic.com/kubeone/master/).

For more commercial information, see [Kubermatic KubeOne](https://www.kubermatic.com/products/kubeone/).

Through the journey of the training, we are now starting with the [Setup](./00_setup/README.md)


## Resume Lab Environment
If you are getting back to Google Cloud Shell and you want to resume access to your cluster,
check these [instructions](00_setup/resume_lab.md).

[**Back to Main**](../README.md)