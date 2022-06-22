KUBEONE_VERSION=1.4.4
KKP_VERSION=2.20.2
# KKP_VERSION=2.20.3
PROJECT_ID=$(shell gcloud projects list --format json | jq .[].name | tr -d \")

.PHONY:
install_k1:
	curl -L https://github.com/kubermatic/kubeone/releases/download/v$(KUBEONE_VERSION)/kubeone_$(KUBEONE_VERSION)_linux_amd64.zip --output /tmp/kubeone.zip
	mkdir -p /tmp/kubeone
	rm -rf /tmp/kubeone/*
	unzip /tmp/kubeone.zip -d /tmp/kubeone
	chmod +x /tmp/kubeone/kubeone
	sudo cp /tmp/kubeone/kubeone /usr/local/bin

.PHONY: install_kkp
install_kkp: install_k1
	curl -L https://github.com/kubermatic/kubermatic/releases/download/v$(KKP_VERSION)/kubermatic-ce-v$(KKP_VERSION)-linux-amd64.tar.gz --output /tmp/kubermatic-ce.tar.gz
	mkdir -p /tmp/kkp
	rm -rf /tmp/kkp/*
	tar -xvf /tmp/kubermatic-ce.tar.gz -C /tmp/kkp	
	chmod +x /tmp/kkp/kubermatic-installer
	sudo cp /tmp/kkp/kubermatic-installer /usr/local/bin

.PHONY: setup_master_folder
setup_master_folder: install_kkp
	mkdir -p ~/master/kubeone
	cp -r /tmp/kubeone/examples/terraform/gce/* ~/master/kubeone
	mkdir -p ~/master/kkp
	cp -r /tmp/kkp/charts ~/master/kkp
	cp /tmp/kkp/examples/kubermatic.example.yaml ~/master/kkp/kubermatic.yaml
	cp /tmp/kkp/examples/values.example.yaml ~/master/kkp/values.yaml

.PHONY: setup_seed_folder
setup_seed_folder: setup_master_folder
	mkdir -p ~/seed/kubeone
	cp -r /tmp/kubeone/examples/terraform/gce/* ~/seed/kubeone
	mkdir -p ~/seed/kkp
	cp /tmp/kkp/examples/seed.example.yaml ~/seed/kkp/seed.yaml

.PHONY: chreate_ssh_key_pair
chreate_ssh_key_pair: setup_seed_folder
	rm -f ~/.ssh/kkp_admin_training
	rm -f ~/.ssh/kkp_admin_training.pub
	ssh-keygen -N '' -f ~/.ssh/kkp_admin_training
	# TODO does not work in makefile
	eval `ssh-agent`
	ssh-add ~/.ssh/kkp_admin_training

.PHONY: copy_kubeone_yaml_files
copy_kubeone_yaml_files: chreate_ssh_key_pair
	cp ./kubeone.yaml ~/master/kubeone
	cp ./kubeone.yaml ~/seed/kubeone

.PHONY: copy_terraform_tfvars_files
copy_terraform_tfvars_files: copy_kubeone_yaml_files
	sed s/\<GCP_PROJECT\>/$(PROJECT_ID)/g ./terraform.tfvars | sed s/\<CLUSTER_NAME\>/master/g > ~/master/kubeone/terraform.tfvars
	sed s/\<GCP_PROJECT\>/$(PROJECT_ID)/g ./terraform.tfvars | sed s/\<CLUSTER_NAME\>/seed/g > ~/seed/kubeone/terraform.tfvars

.PHONY: prepare
prepare: copy_terraform_tfvars_files

.PHONY: terraform_master
terraform_master:
	cd ~/master/kubeone; terraform init
	cd ~/master/kubeone; terraform apply -var=control_plane_target_pool_members_count=1 -auto-approve
	cd ~/master/kubeone; terraform output -json > tf.json

.PHONY: create_master
create_master: terraform_master
	cd ~/master/kubeone; kubeone apply -m kubeone.yaml -t tf.json -y
	cd ~/master/kubeone; terraform apply -auto-approve

.PHONY: terraform_seed
terraform_seed:
	cd ~/seed/kubeone; terraform init
	cd ~/seed/kubeone; terraform apply -var=control_plane_target_pool_members_count=1 -auto-approve
	cd ~/seed/kubeone; terraform output -json > tf.json

.PHONY: create_seed
create_seed: terraform_seed
	cd ~/seed/kubeone; kubeone apply -m kubeone.yaml -t tf.json -y
	cd ~/seed/kubeone; terraform apply -auto-approve
