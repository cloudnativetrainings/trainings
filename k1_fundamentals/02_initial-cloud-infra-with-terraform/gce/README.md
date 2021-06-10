# Cloud Infrastructure Setup at GCE

## Create a SSH keypair
To avoid the usage of your recent private SSH key, you can freshly create one for our training:
```
# SSH Key creation if no ssh key is present

cd [training-repo] #training-repo => folder 'k1_fundamentals'
ssh-keygen -f .secrets/id_rsa
### for now no password is needed, but for prodution would be recommended

ls -la .secrets/id*
```

## Initial Cluster Setup on GCE

Change your folder to the GCE terraform folder [`src/gce/tf-infra`](src/gce/tf-infra) for our terraform GCE code (You will find more terraform examples in the KubeOne repo: [`./examples/terraform/`](https://github.com/kubermatic/kubeone/tree/master/examples/terraform)). 

```bash
cd src/gce/tf-infra
terraform init
```
### Configure terraform setup

Update the `terraform.tfvars` file in the folder. The file will contain specific information about the cluster you are about to create:

```hcl-terraform
cluster_name = "k1"

project = "student-xx-project-name"  #echo $GCP_PROJECT_ID

region = "europe-west4"

# instance to create of the control plane
control_plane_count = 1

# listeners of the Loadbalancer. Default is NOT HA, but ensure the bootstraping works -> after bootstraping we will increase it to e.g. 3
control_plane_target_pool_members_count = 1

### update to your location if needed
ssh_public_key_file = "../../../.secrets/id_rsa.pub"
```


If you are **NOT** using an ssh-agent for the upcoming tasks, please take a look at [How KubeOne uses
SSH](https://github.com/kubermatic/kubeone/blob/master/docs/ssh.md) before you continue. Ensure your `ssh-agent` is stared:
```bash
# Start SSH agent and add key
eval `ssh-agent`
ssh-add ../../../.secrets/id_rsa
```

***Kindly take note of the following:***

1.) Please check the variables.tf file to see other parameters with their default values. The default instance type (n1-standard-2) will be used in this case since we did not specify one.

2.) Depending on the GCP region, you may need to update the **output.tf** file with the correct zone detail. For instance not all regions have zone "a", a good example of this is shown below:

   Available zones in europe-west1 are : ***b, c, d***

   Available zones in europe-west3 are:  ***a, b, c***

   So as an example if you are deploying KubeOne in europe-west1, you will have to update the output.tf as shown below:

   ```hcl-terraform
   zone = "${var.region}-b"
   ```

   Default is "${var.region}-a" which is okay for almost all the regions. If the zone information is not correct, the worker nodes will not be created. The *machinedeployment POD* will also generate an error that the specified zone does not exist in that region.

## Execute terraform changes

You can see the changes to the Google Cloud infrastructure when you use the following commands:
```bash
terraform plan
terraform apply
```
## Verify Output
After everything went well `terraform output` should give you nearly similar content like the following. This output values, will be rendered into your `kubeone.yaml` manifest in the later step. You could also explore the created resources at your cloud provider:
- [Compute Instances](https://console.cloud.google.com/compute/instances)
- [VPC Networks](https://console.cloud.google.com/networking/networks/list)
- [Load balancing](https://console.cloud.google.com/net-services/loadbalancing/loadBalancers)

```bash
terraform output

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
Change now back the core training repo
```bash
cd -
```