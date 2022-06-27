.PHONY: terraform_master
terraform_master:
	cd ~/master/kubeone; terraform init
	cd ~/master/kubeone; terraform apply -var=control_plane_target_pool_members_count=1 -auto-approve
	cd ~/master/kubeone; terraform output -json > tf.json

.PHONY: create_master
create_master: terraform_master
	cd ~/master/kubeone; kubeone apply -m kubeone.yaml -t tf.json -y
	cd ~/master/kubeone; terraform apply -auto-approve
