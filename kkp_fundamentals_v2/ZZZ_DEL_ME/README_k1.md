
# Infra stuff
terraform init
terraform plan -var=control_plane_target_pool_members_count=1
terraform apply -var=control_plane_target_pool_members_count=1 
terraform output -json > tf.json

# create cluster
kubeone apply -m kubeone.yaml -t tf.json --verbose
terraform apply 

# Connect to Cluster
export KUBECONFIG=/home/hubert/Desktop/sva/installation/gcp/kubeone/hubert-sva-segfault-kubeconfig

# delete everything
kubeone reset --manifest kubeone.yaml -t tf.json --verbose
terraform destroy

