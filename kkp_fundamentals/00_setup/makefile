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
	