KUBEONE_VERSION=1.5.1
KKP_VERSION=2.21.1

.PHONY: install_k1
install_k1:
	curl -L https://github.com/kubermatic/kubeone/releases/download/v$(KUBEONE_VERSION)/kubeone_$(KUBEONE_VERSION)_linux_amd64.zip --output ~/.tmp/kubeone-$(KUBEONE_VERSION).zip
	mkdir -p ~/.tmp/kubeone-$(KUBEONE_VERSION)
	rm -rf ~/.tmp/kubeone-$(KUBEONE_VERSION)/*
	unzip ~/.tmp/kubeone-$(KUBEONE_VERSION).zip -d ~/.tmp/kubeone-$(KUBEONE_VERSION)
	chmod +x ~/.tmp/kubeone-$(KUBEONE_VERSION)/kubeone
	sudo cp ~/.tmp/kubeone-$(KUBEONE_VERSION)/kubeone /usr/local/bin

.PHONY: install_kkp
install_kkp:
	curl -L https://github.com/kubermatic/kubermatic/releases/download/v$(KKP_VERSION)/kubermatic-ce-v$(KKP_VERSION)-linux-amd64.tar.gz --output ~/.tmp/kubermatic-ce-$(KKP_VERSION).tar.gz
	mkdir -p ~/.tmp/kubermatic-ce-$(KKP_VERSION)
	rm -rf ~/.tmp/kubermatic-ce-$(KKP_VERSION)/*
	tar -xvf ~/.tmp/kubermatic-ce-$(KKP_VERSION).tar.gz -C ~/.tmp/kubermatic-ce-$(KKP_VERSION)
	chmod +x ~/.tmp/kubermatic-ce-$(KKP_VERSION)/kubermatic-installer
	sudo cp ~/.tmp/kubermatic-ce-$(KKP_VERSION)/kubermatic-installer /usr/local/bin

.PHONY: setup_k1_folder
setup_k1_folder:
	cp -r ~/.tmp/kubeone-$(KUBEONE_VERSION)/examples/terraform/gce/* ~/kubeone
	sed -i 's/GCP_PROJECT/$(PROJECT_ID)/g' ~/kubeone/terraform.tfvars

.PHONY: setup_kkp_folder
setup_kkp_folder:
	cp -r ~/.tmp/kubermatic-ce-$(KKP_VERSION)/charts ~/kkp
	cp ~/.tmp/kubermatic-ce-$(KKP_VERSION)/examples/kubermatic.example.yaml ~/kkp/kubermatic.yaml
	cp ~/.tmp/kubermatic-ce-$(KKP_VERSION)/examples/values.example.yaml ~/kkp/values.yaml
