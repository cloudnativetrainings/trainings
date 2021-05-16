
# GCE Service Account

To communicate with the target cloud, in this case the Google Compute Engine (GCE`), we need a service account at your training project.

Create a service account `k1-service-account` for your Google Cloud resources, with your local [`gcloud`](https://cloud.google.com/sdk/install) CLI.

```bash
##### Ensure that you execute your commands inside of the tooling container

# ensure your connected
gcloud projects list

# create new service account
gcloud iam service-accounts create k1-service-account

# get your service account id
gcloud iam service-accounts list
# get your project id
gcloud projects list

# configure your IDs
export GCP_PROJECT_ID=__YOUR_GCP_PROJECT_ID__                  #student-XX-project
export GCP_SERVICE_ACCOUNT_ID=__YOUR_GCP_SERVICE_ACCOUNT_ID__  # k1-service-account@student-XX.iam.gserviceaccount.com 

# create policy binding
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/compute.admin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/iam.serviceAccountUser' 
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/viewer'

# create a new json key for your service account
cd [training-repo]
mkdir -p ./.secrects && cd ./.secrects 
gcloud iam service-accounts keys create --iam-account $GCP_SERVICE_ACCOUNT_ID k8c-cluster-provisioner-sa-key.json
``` 
Verify at [GCP Cloud Console - Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts) that the service account have been created. Now export your GCP `credentials.json` content with **`cat`**:
```bash
ls -la *.json
export GOOGLE_CREDENTIALS=$(cat ./k8c-cluster-provisioner-sa-key.json)
```
Test if your environment variable contains the json key
```bash
echo $GOOGLE_CREDENTIALS 
{ "type": "service_account", "project_id": "YUOUR PROJECT", "private_key_id": "..." }
# jump back to [training-repo]
cd -
```
