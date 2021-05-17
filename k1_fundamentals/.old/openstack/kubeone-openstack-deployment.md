## Kubeone Deployment Process

**Introduction:** The purpose of this write-up is to document the process of setting up a Kubeone kubernetes cluster, this cluster will eventually be used to install a kubermatic cluster later.

**Pre-requisite:** It is assumed that the reader is fairly familiar with how kubernetes, Openstack and Linux works.

Also make sure that the Openstack environment can support the creation of volumes (cinder, ceph, NFS etc) and a load balancer (LBaaSv2). The volume creation support is required to create PVCs while the LBaaSv2 is required to create Kubernetes service type load balancer.

**Deliverables:**

- Deploy a Kubeone kubernetes cluster on Openstack
- Demonstrate scaling up/down of worker nodes using the Machine controller.
- Install an ingress controller (Nginx) - Check [steps after installing a kubeone cluster](https://github.com/kubermatic/customer-projects/blob/kubeone-kubermatic/training/kubeone-kubermatic/kubeone-deployment-guide.md#deploy-sample-application)
- Install CertManager to cater for SSL certificate management - Check [steps after installing a kubeone cluster](https://github.com/kubermatic/customer-projects/blob/kubeone-kubermatic/training/kubeone-kubermatic/kubeone-deployment-guide.md#deploy-sample-application)
- Install a Demo application to test everything - Check [steps after installing a kubeone cluster](https://github.com/kubermatic/customer-projects/blob/kubeone-kubermatic/training/kubeone-kubermatic/kubeone-deployment-guide.md#deploy-sample-application)
- Upgrade the Kubernetes cluster

Setting up kubeone is mainly a two step process:

- First step is to create an infrastructure using terraform (there are sample terraform templates in the Kubeone repo), this will create all the needed infrastructure nodes like the compute, storage volumes, load balancer for the control plane etc. At the end a tf.json file will be created from the output, this json file consists of all the details of the infrastructure that was created by terraform and it will be used by Kubeone in installing the actual kubernetes cluster.
- Second step is to install the kubernetes cluster using the tf.json (terraform json) file as indicated above, in addition to the tf.json file Kubeone also requires another configuration file (written in yaml), this configuration file will give Kubeone the necessary kubernetes information that is needed to create the cluster, this includes things like kubernetes version to be installed, cloud provider (in this case will be Openstack) etc.

Steps to create a kubeone Cluster on Openstack :

* If you have not install the Openstack cli tools please see https://docs.openstack.org/newton/user-guide/common/cli-install-openstack-command-line-clients.html

- Clone the Loodse training repo: 

  ```git clone git@github.com:kubermatic/customer-projects.git ```

  If you don't have an LBaaS in your Openstack environment, please use the following terraform files instead:  https://github.com/kubermatic/kubeone/tree/master/examples/terraform/openstack

- Source your Openstack credentials:

  ``source ./location_of_openstack_credential``

  Sample credential file should consist of the following parameters:

  ```
  OS_AUTH_URL=...
  OS_IDENTITY_API_VERSION=3
  OS_USERNAME=...
  OS_PASSWORD=...
  OS_REGION_NAME=...
  OS_INTERFACE=public
  OS_ENDPOINT_TYPE=public
  OS_USER_DOMAIN_NAME=...
  OS_DOMAIN_NAME=...
  OS_TENANT_NAME=...
  OS_PROJECT_ID=...
  ```

  

- Change to the Openstack terraform folder (./training/terraform/openstack) and create a terraform.tfvars file which will contain specific information about the cluster you are about create:

  ```
  cluster_name = "kubeone-demo"
  external_network_name = "ext-net"
  image = "Ubuntu Bionic 18.04 (2019-08-02)"
  ```

  These values should be retrieved from your Openstack environment. Make sure you also check the flavor that will be used, default is m1-small, that is why we are not setting this in the terraform.tfvars.

- Initialize terraform: 

  ```terraform init```

* You can see the changes that will be applied using:

  ``terraform plan``

* If all looks good, then you can proceed to apply the changes, starting with just one of the control plane instance connected to the load balancer health-check, the remaining control plane instances (members) will be added to the load balancer health-check afterwards:

  ```terraform apply -var control_plane_target_pool_members_count=1```

* Export the output into tf.json file:

  ```terraform output -json > tf.json```

* Create a cluster config.yaml file:

  ```
  apiVersion: kubeone.io/v1alpha1
  kind: KubeOneCluster
  name: kubeone-demo
  versions:
    kubernetes: '1.14.2'
  cloudProvider:
    name: 'openstack'
    cloudConfig: |
      [Global]
      username="loodse-admin"
      password="xxxxxx"
      auth-url="https://keystone.xxxxx:5000/v3"
      domain-name="Default"
      region="xxxx"
      tenant-name="xxxxxx"
  
      [LoadBalancer]
      lb-version = "v2"
      subnet-id = "b1ccd5ce-f57a-4fa3-b369-a30c92dc1e17"
      floating-network-id = "8bb661f5-76b9-45f1-9ef9-eeffcd025fe4"
      lb-method = "ROUND_ROBIN"
      manage-security-groups = true
  ```
  
  *N.B - It is very important that you use the correct/updated values especially the subnet-id because this will always change every time you install/re-install the cluster using "terraform apply", if the values are not up to date, things like creating service type Load Balancer will not be successful.* 
  
  Sample commands to retrieve some of the these information:
  
  ```
  # Retrieve subnet-id
  $ openstack subnet show kubeone-demo-cluster -c id -f value:
  
  b1ccd5ce-f57a-4fa3-b369-a30c92dc1e17
  
  # Retrieve floating-network-id (this is the external network)
$ openstack network show ext-net -c id -f value:
  
  8bb661f5-76b9-45f1-9ef9-eeffcd025fe4
  ```

* Start the Kubeone installation:

  ```
  kubeone install config.yaml --tfjson tf.json
  ```

```
 INFO[20:44:27 CEST] Installing prerequisites…
  INFO[20:44:28 CEST] Determine operating system…                   node=195.192.128.144
  INFO[20:44:28 CEST] Determine operating system…                   node=195.192.128.189
  INFO[20:44:28 CEST] Determine operating system…                   node=195.192.128.148
  INFO[20:44:29 CEST] Determine hostname…                           node=195.192.128.144
  INFO[20:44:29 CEST] Creating environment file…                    node=195.192.128.144
  INFO[20:44:29 CEST] Installing kubeadm…                 node=195.192.128.144 os=ubuntu
  INFO[20:44:30 CEST] Determine hostname…                           node=195.192.128.189
  INFO[20:44:30 CEST] Creating environment file…                    node=195.192.128.189
  INFO[20:44:30 CEST] Installing kubeadm…                 node=195.192.128.189 os=ubuntu
  INFO[20:44:30 CEST] Determine hostname…                           node=195.192.128.148
  INFO[20:44:30 CEST] Creating environment file…                    node=195.192.128.148
  INFO[20:44:30 CEST] Installing kubeadm…                 node=195.192.128.148 os=ubuntu
  INFO[20:45:36 CEST] Deploying configuration files…      node=195.192.128.148 os=ubuntu
  INFO[20:45:43 CEST] Deploying configuration files…      node=195.192.128.189 os=ubuntu
  INFO[20:45:52 CEST] Deploying configuration files…      node=195.192.128.144 os=ubuntu
  INFO[20:45:53 CEST] Generating kubeadm config file…
  INFO[20:45:54 CEST] Configuring certs and etcd on first controller…
  INFO[20:45:54 CEST] Ensuring Certificates…                        node=195.192.128.189
  INFO[20:45:57 CEST] Downloading PKI files…                        node=195.192.128.189
  INFO[20:45:58 CEST] Creating local backup…                        node=195.192.128.189
  INFO[20:45:58 CEST] Deploying PKI…
  INFO[20:45:58 CEST] Uploading files…                              node=195.192.128.144
  INFO[20:45:58 CEST] Uploading files…                              node=195.192.128.148
  INFO[20:46:01 CEST] Configuring certs and etcd on consecutive controller…
  INFO[20:46:01 CEST] Ensuring Certificates…                        node=195.192.128.144
  INFO[20:46:01 CEST] Ensuring Certificates…                        node=195.192.128.148
  INFO[20:46:04 CEST] Initializing Kubernetes on leader…
  INFO[20:46:04 CEST] Running kubeadm…                              node=195.192.128.189
  INFO[20:47:01 CEST] Joining controlplane node…
  INFO[20:47:01 CEST] Waiting 30s to ensure main control plane components are up…  node=195.192.128.148
  INFO[20:47:31 CEST] Joining control plane node                    node=195.192.128.148
  INFO[20:48:35 CEST] Waiting 30s to ensure main control plane components are up…  node=195.192.128.144
  INFO[20:49:05 CEST] Joining control plane node                    node=195.192.128.144
  INFO[20:50:07 CEST] Copying Kubeconfig to home directory…         node=195.192.128.144
  INFO[20:50:07 CEST] Copying Kubeconfig to home directory…         node=195.192.128.189
  INFO[20:50:07 CEST] Copying Kubeconfig to home directory…         node=195.192.128.148
  INFO[20:50:08 CEST] Building Kubernetes clientset…
  INFO[20:50:13 CEST] Creating credentials secret…
  INFO[20:50:13 CEST] Applying canal CNI plugin…
  INFO[20:50:16 CEST] Installing machine-controller…
  INFO[20:50:20 CEST] Installing machine-controller webhooks…
  INFO[20:50:41 CEST] Waiting for machine-controller to come up…
  INFO[20:52:53 CEST] Creating worker machines…
```

* Add the remaining master nodes to the load balancer health-check:

  ```
  terraform apply
  ```

  A kubeconfig file will be generated after the Kubeone installation, export it and use it to check the status of the kubernetes cluster that was created:

  ```
  export KUBECONFIG=$PWD/kubeone-demo-kubeconfig
  ```

  Run some commands to confirm that the install was successful:

  ```
    kubectl get cs:
    
    NAME                 STATUS    MESSAGE             ERROR
    controller-manager   Healthy   ok                  
    scheduler            Healthy   ok                  
    etcd-0               Healthy   {"health":"true"}   
    
    kubectl get nodes:
    
    NAME                                           STATUS   ROLES    AGE   VERSION
    kubeone-demo-cp-0                              Ready    master   76m   v1.14.2
    kubeone-demo-cp-1                              Ready    master   75m   v1.14.2
    kubeone-demo-cp-2                              Ready    master   73m   v1.14.2
  ```

* Create storage class using the cinder driver:

  ```
  apiVersion: storage.k8s.io/v1
  kind: StorageClass
  metadata:
    name: standard
    annotations:
      storageclass.kubernetes.io/is-default-class: "true"
  provisioner: kubernetes.io/cinder
  ```

  Sample PVC:

  ```
  kind: PersistentVolumeClaim
  apiVersion: v1
  metadata:
    name: myclaim
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 5Gi
  ```

  ```
  kubectl get pvc:
  
  NAME      STATUS   VOLUME                CAPACITY   ACCESS MODES   STORAGECLASS   AGE
  myclaim   Bound    pvc-f68a-fa163e10fc02   5Gi        RWO            standard       8s
  
  ```

  