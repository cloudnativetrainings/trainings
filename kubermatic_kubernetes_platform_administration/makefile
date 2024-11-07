.PHONY: get-google-credentials
get-google-credentials:
	gcloud iam service-accounts create ${GCP_SA_NAME} --display-name="${GCP_SA_NAME}"
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} --member serviceAccount:${GCP_SA_MAIL} --role='roles/compute.admin'
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} --member serviceAccount:${GCP_SA_MAIL} --role='roles/iam.serviceAccountUser'
	gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} --member serviceAccount:${GCP_SA_MAIL} --role='roles/viewer'
	gcloud iam service-accounts keys create --iam-account ${GCP_SA_MAIL} key.json
	mv key.json ~/secrets/key.json

.PHONY: verify
verify: 
	test -n "${GCP_PROJECT_ID}"
	test -n "${GCP_DNS_ZONE}"
	test -n "${GCP_MAIL}"
	test -n "${GCP_SA_NAME}"
	test -n "${GCP_SA_MAIL}"
	test -n "${GCP_DOMAIN}"
	test -n "${GCP_REPO_URL}"
	test -n "${KUBEONE_VERSION}"
	test -n "${KUBEONE_VERSION_NEW}"
	test -n "${KKP_VERSION}"
	test -n "${KKP_VERSION_NEW}"
	test -f secrets/key.json
	test -n '${GOOGLE_CREDENTIALS}'
# TODO test other tools - uuid-runtime apache2-utils
	yq --version
	echo "Training Environment successfully verified"

.PHONY: teardown
teardown: 
# TODO delete all user cluster vms
	kubectl -n kube-system scale md --all --replicas 0
	cd ~/kubeone; kubeone reset --manifest kubeone.yaml -t tf.json -y
	cd ~/kubeone; terraform destroy -auto-approve

.PHONY: teardown-training-environment
teardown-training-environment:
# TODO does not work => needs IP adress
# gcloud dns record-sets transaction start --zone=$(GCP_DNS_ZONE)
# gcloud dns record-sets transaction remove --zone=$(GCP_DNS_ZONE) --type A $(IP) --name="$(GCP_DOMAIN)." 
# gcloud dns record-sets transaction remove --zone=$(GCP_DNS_ZONE) --type A $(IP) --name="*.$(GCP_DOMAIN)."
# gcloud dns record-sets transaction remove --zone=$(GCP_DNS_ZONE) --type A $(IP) --name="*.kubermatic.$(GCP_DOMAIN)." 
# gcloud dns record-sets transaction execute --zone $(GCP_DNS_ZONE)
	gcloud iam service-accounts delete $(GCP_SA_MAIL) --quiet
	sudo rm -rf ~/* ~/.tmp ~/.trainingrc
