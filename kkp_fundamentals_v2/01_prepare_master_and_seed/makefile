KUBEONE_VERSION=1.4.4
KKP_VERSION=2.20.2
PROJECT_ID=$(shell gcloud projects list --format json | jq .[].name | tr -d \")

.PHONY: install_tools
install_tools:
	sudo apt-get install -y uuid-runtime apache2-utils 

.PHONY: install_k1
install_k1: install_tools
	curl -L https://github.com/kubermatic/kubeone/releases/download/v$(KUBEONE_VERSION)/kubeone_$(KUBEONE_VERSION)_linux_amd64.zip --output ~/.tmp/kubeone.zip
	mkdir -p ~/.tmp/kubeone
	rm -rf ~/.tmp/kubeone/*
	unzip ~/.tmp/kubeone.zip -d ~/.tmp/kubeone
	chmod +x ~/.tmp/kubeone/kubeone
	sudo cp ~/.tmp/kubeone/kubeone /usr/local/bin

.PHONY: install_kkp
install_kkp: install_k1
	curl -L https://github.com/kubermatic/kubermatic/releases/download/v$(KKP_VERSION)/kubermatic-ce-v$(KKP_VERSION)-linux-amd64.tar.gz --output ~/.tmp/kubermatic-ce.tar.gz
	mkdir -p ~/.tmp/kkp
	rm -rf ~/.tmp/kkp/*
	tar -xvf ~/.tmp/kubermatic-ce.tar.gz -C ~/.tmp/kkp	
	chmod +x ~/.tmp/kkp/kubermatic-installer
	sudo cp ~/.tmp/kkp/kubermatic-installer /usr/local/bin

.PHONY: setup_master_folder
setup_master_folder: install_kkp
	cp -r ~/.tmp/kubeone/examples/terraform/gce/* ~/master/kubeone
	cp -r ~/.tmp/kkp/charts ~/master/kkp
	cp ~/.tmp/kkp/examples/kubermatic.example.yaml ~/master/kkp/kubermatic.yaml
	cp ~/.tmp/kkp/examples/values.example.yaml ~/master/kkp/values.yaml

.PHONY: setup_seed_folder
setup_seed_folder: setup_master_folder
	cp -r ~/.tmp/kubeone/examples/terraform/gce/* ~/seed/kubeone
	cp -r ~/.tmp/kkp/charts ~/seed/kkp
	cp ~/.tmp/kkp/examples/kubermatic.example.yaml ~/seed/kkp/kubermatic.yaml
	cp ~/.tmp/kkp/examples/values.example.yaml ~/seed/kkp/values.yaml

.PHONY: copy_kubeone_files
copy_kubeone_files: setup_seed_folder
# TODO maybe does not work properly
	sed -i 's/\<GCP_PROJECT\>/$(PROJECT_ID)/g' ~/master/kubeone/terraform.tfvars
	sed -i 's/\<GCP_PROJECT\>/$(PROJECT_ID)/g' ~/seed/kubeone/terraform.tfvars

.PHONY: prepare
prepare: copy_kubeone_files
