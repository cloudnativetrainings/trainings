KUBEONE_VERSION=1.4.4
KKP_VERSION=2.20.3
PROJECT_ID=$(shell gcloud projects list --format json | jq .[].name | tr -d \")
SA_NAME=kkp-admin-training
SA_EMAIL=$(SA_NAME)@$(PROJECT_ID).iam.gserviceaccount.com

.PHONY: clean_up
clean_up:
	rm -rf /tmp/kubeone
	rm -rf /tmp/kkp
	rm -rf ~/master
	rm -rf ~/seed
	rm -rf ~/key.json

.PHONY: get_gcp_sa_key
get_gcp_sa_key: 
	gcloud iam service-accounts create $(SA_NAME) --display-name="$(SA_NAME)"
	gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(SA_EMAIL) --role='roles/compute.admin'
	gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(SA_EMAIL) --role='roles/iam.serviceAccountUser'
	gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(SA_EMAIL) --role='roles/viewer'
	gcloud iam service-accounts keys create --iam-account $(SA_EMAIL) key.json

.PHONY: install_k1
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

.PHONY: install
install: setup_seed_folder

