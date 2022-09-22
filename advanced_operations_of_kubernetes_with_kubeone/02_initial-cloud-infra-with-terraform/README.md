# Cloud Infrastructure Setup using Terraform at GCE

## Create an SSH key-pair

To avoid the usage of your recent private SSH key, you can freshly create one for our training:

* Create SSH Key, if no ssh key is present
  ```bash
  cd $TRAINING_DIR
  ssh-keygen -f .secrets/id_rsa
  ```
  >HINT: For now no password is needed, but for prodution would be recommended
  
  ```bash
  ls -la .secrets/id*
  ```

## Initial Cluster Setup on GCE

* Change your folder to the GCE terraform folder [`src/gce/tf-infra`](../src/gce/tf-infra) for our terraform GCE code and initialize terraform (You will find more terraform examples in the KubeOne repo under [`examples/terraform`](https://github.com/kubermatic/kubeone/tree/master/examples/terraform) folder. 
  ```bash
  cd $TRAINING_DIR/src/gce/tf-infra
  terraform init
  ```

* Configure terraform setup

  Update the `terraform.tfvars` file in the folder. The file will contain specific information about the cluster you are about to create:
  ```hcl-terraform
  # Update the cluster name 
  cluster_name = "k1"

  # Echo $GCP_PROJECT_ID and update the project id
  project = "student-xx-project-name"  
  
  region = "europe-west4"
  
  # Instance to create of the control plane
  control_plane_count = 1  

  # Listeners of the LoadBalancer. Default is NOT HA, but ensure the bootstrapping works -> after bootstrapping we will increase it to e.g. 3
  control_plane_target_pool_members_count = 1
  
  # Update to your SSH public key location, navigate to the .secrets dir and $PWD to get full path
  ssh_public_key_file = "/path/to/.secrets/id_rsa.pub"

  # Update to your SSH private key location, navigate to the .secrets dir and $PWD to get full path
  ssh_private_key_file = "/path/to/.secrets/id_rsa"
  ```

* If you are **NOT** using a ssh-agent for the upcoming tasks, please take a look at [How KubeOne uses
SSH](https://github.com/kubermatic/kubeone/blob/master/docs/ssh.md) before you continue. Ensure your `ssh-agent` is started and SSH private key is added:
  ```bash
  eval `ssh-agent`
  ssh-add /path/to/.secrets/id_rsa
  ```
  >Update as per your SSH private key location `/path/to/.secrets/id_rsa`

***Kindly take note of the following:***

1. Please check the `variables.tf` file to see other parameters with their default values. The default instance type (`n1-standard-2`) will be used in this case since we did not specify one.

2. Depending on the GCP region, you may need to update the `output.tf` file with the correct zone detail. For instance not all regions have a zone `a`, a good example of this is shown below:

   Available zones in europe-west1 are : `b, c, d`

   Available zones in europe-west3 are:  `a, b, c`

   So as an example if you are deploying KubeOne in europe-west1, you will have to update the output.tf as shown below:

   ```hcl-terraform
   zone = "${var.region}-b"
   ```

   Default is `${var.region}-a` which is fine for almost all the regions. If the zone information is not correct, the worker nodes will not be created. The *machinedeployment POD* will also generate an error that the specified zone does not exist in that region.

## Execute terraform changes

* You can see the changes to the Google Cloud infrastructure when you use the following commands:
  ```bash
  terraform plan
  terraform apply
  ```

## Verify Output
* After everything went well `terraform output` should give you nearly similar content like the following. This output values, will be rendered into your `kubeone.yaml` manifest in the later step. You could also explore the created resources at your cloud provider:
  - [Compute Instances](https://console.cloud.google.com/compute/instances)
  - [VPC Networks](https://console.cloud.google.com/networking/networks/list)
  - [Load balancing](https://console.cloud.google.com/net-services/loadbalancing/loadBalancers)

  ```bash
  terraform output
  ```

  ```bash
  kubeone_api = {
    "endpoint" = "34.141.176.241"
  }
  kubeone_hosts = {
    "control_plane" = {
      "cloud_provider" = "gce"
      "cluster_name" = "k1"
      "hostnames" = [
        "k1-control-plane-1",
      ]
      "private_address" = [
        "10.240.0.2",
      ]
      "public_address" = [
        "34.141.138.245",
      ]
      "ssh_agent_socket" = "env:SSH_AUTH_SOCK"
      "ssh_port" = 22
      "ssh_private_key_file" = ""
      "ssh_user" = "root"
    }
  }
  kubeone_workers = {
    "k1-pool-az-a" = {
      "providerSpec" = {
        "cloudProviderSpec" = {
          "assignPublicIPAddress" = true
          "diskSize" = 50
          "diskType" = "pd-ssd"
          "labels" = {
            "k1-workers" = "pool-az-a"
          }
          "machineType" = "n1-standard-2"
          "multizone" = true
          "network" = "https://www.googleapis.com/compute/v1/projects/test-01-int-05/global/networks/k1"
          "preemptible" = false
          "regional" = false
          "subnetwork" = "https://www.googleapis.com/compute/v1/projects/test-01-int-05/regions/europe-west4/subnetworks/k1-subnet"
          "tags" = [
            "firewall",
            "targets",
            "k1-pool-az-a",
          ]
          "zone" = "europe-west4-a"
        }
        "operatingSystem" = "ubuntu"
        "operatingSystemSpec" = {
          "distUpgradeOnBoot" = false
        }
        "sshPublicKeys" = [
          <<-EOT
          ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvxsGRbxpkpYqjsHmlO0EYtGtxrlXc5vDYwz+CbzWHXiow/XK/3NE2l5XljvsVLvhDmFjP/06zWCBAP9HjV/Vh2Mk0LqDfyLgQOTCspQmxykHp6gSqbVmhn70wl2hMkpq685GlZGRLi7iGoHhJddsrmQUD+dxIeAtUqfcVDn1oP3Mdp+5FdHy9oIcAOp4Trzki16ZS+ee6JYKrGXzcFF1eNM5rVGOk7vMDiM9eOTCEho2UPToZUcKrA3HfpyVR7H5jT4grnQlm/anLB9YnKO9/n2bI2CtDep7POK4yNrVH7a2HMNBJA9gicvLz+un26LSH10Hat60IAQjb4JWqMb1XMvupGaqW5M/ZLOd9JzQOvMurdSx4rFOkM4GpHyZM8J1COJrYiMSesHIiEHc2PUUwzNggSQLMag2b1haj0jbCvV+xgSBSojjPtqKVYg849ockpePMRJRVxyiIUbfdFkJ7VkuG9Op3KAd5URJWXVzFKlq0qBvCthq18ltMutPjYNk= kubermatic@7e54c85f5e39
          
          EOT,
        ]
      }
      "replicas" = 1
    }
  }
  ```

* Now change back the root of a training repo
  ```bash
  cd -
  ```

Jump > [**Home**](../README.md) | Previous > [**GCE Service Account Setup**](../01_create-cloud-credentials/README.md) | Next > [**First KubeOne Cluster Setup**](../03_first-kubeone-cluster/README.md)