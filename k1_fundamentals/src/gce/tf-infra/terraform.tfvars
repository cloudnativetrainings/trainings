# Update the cluster name
cluster_name = "k1"

# Echo $GCP_PROJECT_ID and update the project id
project = "TODO-ADD-YOUR-PROJECT"

region = "europe-west4"

# instance to create of the control plane
control_plane_count = 1

# listeners of the Loadbalancer. Default is NOT HA, but ensure the bootstrapping works -> after bootstrapping increase to e.g. 3
control_plane_target_pool_members_count = 1
  
# Update to your SSH public key location
ssh_public_key_file = "/path/to/.secrets/id_rsa.pub"

# Update to your SSH private key location
ssh_private_key_file = "/path/to/.secrets/id_rsa"
