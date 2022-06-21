PROJECT_ID=$(shell gcloud projects list --format json | jq .[].name | tr -d \")
SA_NAME=kkp-admin-training
SA_EMAIL=$(SA_NAME)@$(PROJECT_ID).iam.gserviceaccount.com

.PHONY: get_gcp_sa_key
get_gcp_sa_key: 
	gcloud iam service-accounts create $(SA_NAME) --display-name="$(SA_NAME)"
	gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(SA_EMAIL) --role='roles/compute.admin'
	gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(SA_EMAIL) --role='roles/iam.serviceAccountUser'
	gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(SA_EMAIL) --role='roles/viewer'
	gcloud iam service-accounts keys create --iam-account $(SA_EMAIL) key.json
	mv key.json ~/key.json
