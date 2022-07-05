.PHONY: terraform
terraform:
	cd ~/kubeone; terraform init
	cd ~/kubeone; terraform apply -var=control_plane_target_pool_members_count=1 -auto-approve
	cd ~/kubeone; terraform output -json > tf.json

.PHONY: create_cluster
create_cluster:
	cd ~/kubeone; kubeone apply -m kubeone.yaml -t tf.json -y
	cd ~/kubeone; terraform apply -auto-approve
