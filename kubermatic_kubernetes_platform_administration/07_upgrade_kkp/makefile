.PHONY: install_new_kkp
install_new_kkp:
	curl -L https://github.com/kubermatic/kubermatic/releases/download/v$(KKP_VERSION_NEW)/kubermatic-ce-v$(KKP_VERSION_NEW)-linux-amd64.tar.gz --output ~/.tmp/kubermatic-ce-$(KKP_VERSION_NEW).tar.gz
	mkdir -p ~/.tmp/kubermatic-ce-$(KKP_VERSION_NEW)
	rm -rf ~/.tmp/kubermatic-ce-$(KKP_VERSION_NEW)/*
	tar -xvf ~/.tmp/kubermatic-ce-$(KKP_VERSION_NEW).tar.gz -C ~/.tmp/kubermatic-ce-$(KKP_VERSION_NEW)
	chmod +x ~/.tmp/kubermatic-ce-$(KKP_VERSION_NEW)/kubermatic-installer
	sudo cp ~/.tmp/kubermatic-ce-$(KKP_VERSION_NEW)/kubermatic-installer ~/bin/kubermatic-installer
	rm -rf ~/kkp/charts
	cp -r ~/.tmp/kubermatic-ce-$(KKP_VERSION_NEW)/charts ~/kkp
