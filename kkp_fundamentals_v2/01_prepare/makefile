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

.PHONY: setup_kubeone_folder
setup_kubeone_folder: install_kkp
	cp -r ~/.tmp/kubeone/examples/terraform/gce/* ~/kubeone
	sed -i 's/GCP_PROJECT/$(PROJECT_ID)/g' ~/kubeone/terraform.tfvars

.PHONY: setup_kkp_folder
setup_kkp_folder: setup_kubeone_folder
	cp -r ~/.tmp/kkp/charts ~/kkp
	cp ~/.tmp/kkp/examples/kubermatic.example.yaml ~/kkp/kubermatic.yaml
	cp ~/.tmp/kkp/examples/values.example.yaml ~/kkp/values.yaml

.PHONY: prepare
prepare: setup_kkp_folder
