.PHONY: install_kkp
install_kkp:
	curl -L https://github.com/kubermatic/kubermatic/releases/download/v$(KKP_VERSION)/kubermatic-ce-v$(KKP_VERSION)-linux-amd64.tar.gz --output ~/.tmp/kubermatic-ce-$(KKP_VERSION).tar.gz
	mkdir -p ~/.tmp/kubermatic-ce-$(KKP_VERSION)
	rm -rf ~/.tmp/kubermatic-ce-$(KKP_VERSION)/*
	tar -xvf ~/.tmp/kubermatic-ce-$(KKP_VERSION).tar.gz -C ~/.tmp/kubermatic-ce-$(KKP_VERSION)
	chmod +x ~/.tmp/kubermatic-ce-$(KKP_VERSION)/kubermatic-installer
	sudo cp ~/.tmp/kubermatic-ce-$(KKP_VERSION)/kubermatic-installer ~/bin

.PHONY: setup_kkp_folder
setup_kkp_folder:
	cp -r ~/.tmp/kubermatic-ce-$(KKP_VERSION)/charts ~/kkp
	cp ~/.tmp/kubermatic-ce-$(KKP_VERSION)/examples/kubermatic.example.yaml ~/kkp/kubermatic.yaml
	cp ~/.tmp/kubermatic-ce-$(KKP_VERSION)/examples/values.example.yaml ~/kkp/values.yaml

.PHONY: create_dns_records
create_dns_records: 
	gcloud dns record-sets transaction start --zone=$(GCP_DNS_ZONE)
	gcloud dns record-sets transaction add --zone=$(GCP_DNS_ZONE) --ttl 60 --name="$(GCP_DOMAIN)." --type A $(IP)
	gcloud dns record-sets transaction add --zone=$(GCP_DNS_ZONE) --ttl 60 --name="*.$(GCP_DOMAIN)."  --type A $(IP)
	gcloud dns record-sets transaction execute --zone $(GCP_DNS_ZONE)
