.PHONY: terraform_seed
terraform_seed:
	cd ~/seed/kubeone; terraform init
	cd ~/seed/kubeone; terraform apply -var=control_plane_target_pool_members_count=1 -auto-approve
	cd ~/seed/kubeone; terraform output -json > tf.json

.PHONY: create_seed
create_seed: terraform_seed
	cd ~/seed/kubeone; kubeone apply -m kubeone.yaml -t tf.json -y
	cd ~/seed/kubeone; terraform apply -auto-approve
