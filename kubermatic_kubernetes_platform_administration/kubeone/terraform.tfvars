project = "GCP_PROJECT"
cluster_name = "kkp-master-seed-cluster"
region = "europe-west3"

ssh_private_key_file = "~/secrets/kkp_admin_training"
ssh_public_key_file = "~/secrets/kkp_admin_training.pub"

control_plane_image_family = "ubuntu-2404-lts-amd64"
control_plane_type = "n1-standard-4"

worker_os = "ubuntu"
workers_type = "n1-standard-4"
initial_machinedeployment_replicas = 1