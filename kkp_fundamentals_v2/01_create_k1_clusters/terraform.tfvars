project = "<GCP_PROJECT>"
cluster_name = "<CLUSTER_NAME>"
region = "europe-west3"

ssh_private_key_file = "~/.ssh/kkp_admin_training"
ssh_public_key_file = "~/.ssh/kkp_admin_training.pub"

control_plane_image_family = "ubuntu-2004-lts"
# TODO does not work for whatever reason => gets 3
# TODO
# control_plane_target_pool_members_count = "1"
control_plane_type = "n1-standard-4"

worker_os = "ubuntu"
# TODO
workers_replicas = "1"
workers_type = "n1-standard-4"
