KUBEONE_VERSION=1.4.4
KKP_VERSION=2.20.3
PROJECT_ID=$(shell gcloud projects list --format json | jq .[].name | tr -d \")

.PHONY:
install_k1: clean_up
	curl -L https://github.com/kubermatic/kubeone/releases/download/v$(KUBEONE_VERSION)/kubeone_$(KUBEONE_VERSION)_linux_amd64.zip --output /tmp/kubeone.zip
	unzip /tmp/kubeone.zip -d /tmp/kubeone
	chmod +x /tmp/kubeone/kubeone
	sudo cp /tmp/kubeone/kubeone /usr/local/bin

.PHONY: install_kkp
install_kkp: install_k1
	curl -L https://github.com/kubermatic/kubermatic/releases/download/v$(KKP_VERSION)/kubermatic-ce-v$(KKP_VERSION)-linux-amd64.tar.gz --output /tmp/kubermatic-ce.tar.gz
	mkdir -p /tmp/kkp
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
chreate_ssh_key_pair: setup_master_folder
	ssh-keygen -N '' -f ~/.ssh/kkp_admin_training

.PHONY: copy_kubeone_yaml_files
copy_kubeone_yaml_files: 
	cp ~/trainings/kkp_fundamentals_v2/01_setup_project_structure/kubeone.yaml ~/master/kubeone
	cp ~/trainings/kkp_fundamentals_v2/01_setup_project_structure/kubeone.yaml ~/seed/kubeone

.PHONY: copy_terraform_tfvars_files
copy_terraform_tfvars_files: 
	# TODO v2
	sed s/\<GCP_PROJECT\>/$(PROJECT_ID)/g ~/trainings/kkp_fundamentals_v2/01_create_k1_clusters/terraform.tfvars | sed s/\<CLUSTER_NAME\>/master/g > ~/master/kubeone/terraform.tfvars
	sed s/\<GCP_PROJECT\>/$(PROJECT_ID)/g ~/trainings/kkp_fundamentals_v2/01_create_k1_clusters/terraform.tfvars | sed s/\<CLUSTER_NAME\>/seed/g > ~/seed/kubeone/terraform.tfvars

# TODO get rid of tasks folder

.PHONY: install
install: setup_seed_folder

