.PHONY: get-google-credentials
get-google-credentials:
	gcloud config set project ${GCP_PROJECT_ID}
	gcloud iam service-accounts create ${GCP_SA_NAME} --display-name="${GCP_SA_NAME}"
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} --member serviceAccount:${GCP_SA_MAIL} --role='roles/compute.admin'
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} --member serviceAccount:${GCP_SA_MAIL} --role='roles/iam.serviceAccountUser'
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} --member serviceAccount:${GCP_SA_MAIL} --role='roles/viewer'
	gcloud iam service-accounts keys create --iam-account ${GCP_SA_MAIL} google-sa-key.json
	mv google-sa-key.json ~/secrets/google-sa-key.json

.PHONY: verify
verify: 
	@printf "%-40s : " "GCP_PROJECT_ID environment variable" && test -n "${GCP_PROJECT_ID}" && printf "\e[32m%s\e[0m\n" "OK" || printf "\e[31m%s\e[0m\n" "NOK"
	@printf "%-40s : " "GCP_DNS_ZONE environment variable" && test -n "${GCP_DNS_ZONE}" && printf "\e[32m%s\e[0m\n" "OK" || printf "\e[31m%s\e[0m\n" "NOK"
	@printf "%-40s : " "GCP_MAIL environment variable" && test -n "${GCP_MAIL}" && printf "\e[32m%s\e[0m\n" "OK" || printf "\e[31m%s\e[0m\n" "NOK"
	@printf "%-40s : " "GCP_SA_NAME environment variable" && test -n "${GCP_SA_NAME}" && printf "\e[32m%s\e[0m\n" "OK" || printf "\e[31m%s\e[0m\n" "NOK"
	@printf "%-40s : " "GCP_SA_MAIL environment variable" && test -n "${GCP_SA_MAIL}"&& printf "\e[32m%s\e[0m\n" "OK" || printf "\e[31m%s\e[0m\n" "NOK"
	@printf "%-40s : " "GCP_DOMAIN environment variable" && test -n "${GCP_DOMAIN}" && printf "\e[32m%s\e[0m\n" "OK" || printf "\e[31m%s\e[0m\n" "NOK"
	@printf "%-40s : " "KUBEONE_VERSION environment variable" && test -n "${KUBEONE_VERSION}" && printf "\e[32m%s\e[0m\n" "OK" || printf "\e[31m%s\e[0m\n" "NOK"
	@printf "%-40s : " "KKP_VERSION environment variable" && test -n "${KKP_VERSION}" && printf "\e[32m%s\e[0m\n" "OK" || printf "\e[31m%s\e[0m\n" "NOK"
	@printf "%-40s : " "KKP_VERSION_NEW environment variable" && test -n "${KKP_VERSION_NEW}" && printf "\e[32m%s\e[0m\n" "OK" || printf "\e[31m%s\e[0m\n" "NOK"
	@printf "%-40s : " "Service Account Key File" && test -f ~/secrets/google-sa-key.json && printf "\e[32m%s\e[0m\n" "OK" || printf "\e[31m%s\e[0m\n" "NOK"
# TODO does not work due to json data test -n '${GOOGLE_CREDENTIALS}'
# TODO test other tools - uuid-runtime apache2-utils
	@yq --version
	@echo "Training Environment successfully verified"

.PHONY: teardown
teardown: 
	gcloud iam service-accounts delete $(GCP_SA_MAIL) --quiet
	rm -rf ~/* ~/.tmp ~/.trainingrc
