# Kubermatic Kubernetes Platform Introduction Guide

**Introduction:** The purpose of this write-up is to document the process of setting up a Kubermatic cluster.

Kubermatic is a cluster-as-a-service solution that provides managed Kubernetes for your infrastructure.

## Terminology

- **User/Customer cluster** – A Kubernetes cluster created and managed by Kubermatic
- **Seed cluster** – A Kubernetes cluster which is responsible for hosting the master components of a customer cluster
- **Master cluster** – A Kubernetes cluster which is responsible for storing the information about users, projects and SSH keys. It hosts the Kubermatic components and might also act as a seed cluster.
- **Seed datacenter** – A definition/reference to a seed cluster
- **Node datacenter** – A definition/reference of a datacenter/region/zone at a cloud provider (aws=zone, digitalocean=region, openstack=zone)

**N.B -- For further references, kindly check the official documentation** https://docs.kubermatic.com/

## Prerequisites 
- Founded Kubernetes knowledge and tooling usage

## Deliverables

* Kubermatic Installation
  * Combined Master/Seed setup
  * Kubermatic UI / REST-API
  * Monitoring / Logging Stack
* User cluster creation for applied datacenters
  * GCE
  * AWS
* Introduction into main operational tasks and concepts

## Requirements

* It is assumed that the reader is fairly familiar with how Kubernetes and Linux works and the usage of some common tooling
  * `kubectl`
  * `vim` or other CLI editor
  * `helm` (version 3+)

* You finished KubeOne Training: [../k1_fundamentals](../k1_fundamentals) and already have a KubeOne Kubernetes cluster (GCP will be used for this exercise). 

* To understand the general prerequisites take a look at [Cluster Requirements](https://docs.kubermatic.com/kubermatic/master/requirements/cluster_requirements/)

Now Start with [00-prepare-training-lab](./00-prepare-training-lab).
