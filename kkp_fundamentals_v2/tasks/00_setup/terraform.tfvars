project = "loodse-training-playground"
cluster_name = "hubert-sva-segfault"

region = "europe-west3"

ssh_private_key_file = "/home/hubert/.ssh/hubert-sva-segfault"
ssh_public_key_file = "/home/hubert/.ssh/hubert-sva-segfault.pub"
ssh_username = "hubert"

control_plane_image_family = "rhel-8"
control_plane_image_project = "rhel-cloud" 
control_plane_type = "n1-standard-2"

workers_type = "n1-standard-2"
# worker_os = "rhel"
worker_os = "ubuntu"

