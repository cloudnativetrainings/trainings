.PHONY: install_new_kkp
install_new_kkp:
	curl -L https://github.com/kubermatic/kubermatic/releases/download/v$(KKP_VERSION_NEW)/kubermatic-ce-v$(KKP_VERSION_NEW)-linux-amd64.tar.gz --output ~/.tmp/kubermatic-ce-$(KKP_VERSION_NEW).tar.gz
	mkdir -p ~/.tmp/kkp-$(KKP_VERSION_NEW)
	rm -rf ~/.tmp/kkp-$(KKP_VERSION_NEW)/*
	tar -xvf ~/.tmp/kubermatic-ce-$(KKP_VERSION_NEW).tar.gz -C ~/.tmp/kkp-$(KKP_VERSION_NEW)
	chmod +x ~/.tmp/kkp-$(KKP_VERSION_NEW)/kubermatic-installer
	sudo cp ~/.tmp/kkp-$(KKP_VERSION_NEW)/kubermatic-installer /usr/local/bin/kubermatic-installer-$(KKP_VERSION_NEW)

.PHONY: setup_new_master_folder
setup_new_master_folder: install_new_kkp
	mkdir -p ~/master/kkp-$(KKP_VERSION_NEW)
	cp -r ~/.tmp/kkp-$(KKP_VERSION_NEW)/charts ~/master/kkp-$(KKP_VERSION_NEW)
	cp ~/master/kkp/kubermatic.yaml ~/master/kkp-$(KKP_VERSION_NEW)/kubermatic.yaml
	cp ~/master/kkp/values.yaml ~/master/kkp-$(KKP_VERSION_NEW)/values.yaml
