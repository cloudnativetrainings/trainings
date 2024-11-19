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
	@test -n "${GCP_PROJECT_ID}" && printf "%-30s \e[32m%s\e[0m\n" "GCP_PROJECT_ID" "OK"  || printf "%-30s \e[31m%s\e[0m\n" "GCP_PROJECT_ID" "NOK"
	@test -n "${GCP_DNS_ZONE}" && printf "%-30s \e[32m%s\e[0m\n" "GCP_DNS_ZONE" "OK"  || printf "%-30s \e[31m%s\e[0m\n" "GCP_DNS_ZONE" "NOK"
	@test -n "${GCP_MAIL}" && printf "%-30s \e[32m%s\e[0m\n" "GCP_MAIL" "OK"  || printf "%-30s \e[31m%s\e[0m\n" "GCP_MAIL" "NOK"
	@test -n "${GCP_SA_NAME}" && printf "%-30s \e[32m%s\e[0m\n" "GCP_SA_NAME" "OK"  || printf "%-30s \e[31m%s\e[0m\n" "GCP_SA_NAME" "NOK"
	@test -n "${GCP_SA_MAIL}" && printf "%-30s \e[32m%s\e[0m\n" "GCP_SA_MAIL" "OK"  || printf "%-30s \e[31m%s\e[0m\n" "GCP_SA_MAIL" "NOK"
	@test -n "${GCP_DOMAIN}" && printf "%-30s \e[32m%s\e[0m\n" "GCP_DOMAIN" "OK"  || printf "%-30s \e[31m%s\e[0m\n" "GCP_DOMAIN" "NOK"
	@test -n "${KUBEONE_VERSION}" && printf "%-30s \e[32m%s\e[0m\n" "KUBEONE_VERSION" "OK"  || printf "%-30s \e[31m%s\e[0m\n" "KUBEONE_VERSION" "NOK"
	@test -n "${KKP_VERSION}" && printf "%-30s \e[32m%s\e[0m\n" "KKP_VERSION" "OK"  || printf "%-30s \e[31m%s\e[0m\n" "KKP_VERSION" "NOK"
	@test -n "${KKP_VERSION_NEW}" && printf "%-30s \e[32m%s\e[0m\n" "KKP_VERSION_NEW" "OK"  || printf "%-30s \e[31m%s\e[0m\n" "KKP_VERSION_NEW" "NOK"
	@test -f secrets/google-sa-key.json && printf "%-30s \e[32m%s\e[0m\n" "Service Account Key File" "OK"  || printf "%-30s \e[31m%s\e[0m\n" "Service Account Key File" "NOK"
# TODO does not work due to json data test -n '${GOOGLE_CREDENTIALS}'
# TODO test other tools - uuid-runtime apache2-utils
	@yq --version
	@echo "Training Environment successfully verified"

.PHONY: teardown
teardown: 
	gcloud iam service-accounts delete $(GCP_SA_MAIL) --quiet
	rm -rf ~/* ~/.tmp ~/.trainingrc
