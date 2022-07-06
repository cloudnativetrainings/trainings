.PHONY: set_env_vars
set_env_vars: 
	echo 'export PROJECT_ID=$(gcloud projects list --format json | jq .[].name | tr -d \")' >> ~/.bashrc
	echo 'export DNS_ZONE=$(gcloud dns managed-zones list --format json | jq '.[].name' | tr -d \")' >> ~/.bashrc
	echo 'export MAIL=$(PROJECT_ID)@loodse.training' >> ~/.bashrc
	echo 'export SA_NAME=kkp-admin-training' >> ~/.bashrc
	echo 'export SA_MAIL=$(SA_NAME)@$(PROJECT_ID).iam.gserviceaccount.com' >> ~/.bashrc
	echo 'export DOMAIN=$(PROJECT_ID).loodse.training' >> ~/.bashrc
	echo 'export REPO_URL=gcr.io/$(PROJECT_ID)' >> ~/.bashrc
# TODO move stuff in file and cat it into .bashrc => safeguard via ifs

.PHONY: get_gcp_sa_key
get_gcp_sa_key: 
	mkdir -p ~/secrets
	gcloud iam service-accounts create $(SA_NAME) --display-name="$(SA_NAME)"
	gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(SA_MAIL) --role='roles/compute.admin'
	gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(SA_MAIL) --role='roles/iam.serviceAccountUser'
	gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(SA_MAIL) --role='roles/viewer'
	gcloud iam service-accounts keys create --iam-account $(SA_MAIL) key.json
	mv key.json ~/secrets/key.json

.PHONY: install_tools
install_tools:
	sudo apt-get install -y uuid-runtime apache2-utils
	sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
	sudo chmod a+x /usr/local/bin/yq
	echo 'source <(kubectl completion bash)' >>~/.bashrc
