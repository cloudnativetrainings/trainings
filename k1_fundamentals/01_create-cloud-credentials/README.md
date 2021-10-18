# GCE Service Account

To communicate with the target cloud, in this case the Google Compute Engine (GCE), we need a service account at your training project.

Create a service account `k1-service-account` for your Google Cloud resources, with your local [`gcloud`](https://cloud.google.com/sdk/install) CLI.

>Ensure that you execute your commands inside of the tooling container

* Ensure that you are connected and get your Project ID
  ```bash
  gcloud projects list
  ```

* Create new service account
  ```bash
  gcloud iam service-accounts create k1-service-account
  ```

* Get your service account id
  ```bash
  gcloud iam service-accounts list
  ```

* Configure your IDs
  ```bash
  export GCP_PROJECT_ID=__YOUR_GCP_PROJECT_ID__                  #student-XX-project
  export GCP_SERVICE_ACCOUNT_ID=__YOUR_GCP_SERVICE_ACCOUNT_ID__  # k1-service-account@student-XX-project.iam.gserviceaccount.com
  ```

* Create policy binding
  ```bash
  gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/compute.admin'
  gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/iam.serviceAccountUser'
  gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/viewer'
  gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/storage.admin'
  ```

* Create a new json key for your service account
  ```bash
  cd $TRAINING_DIR
  mkdir -p ./.secrets && cd ./.secrets
  gcloud iam service-accounts keys create --iam-account $GCP_SERVICE_ACCOUNT_ID k8c-cluster-provisioner-sa-key.json
  ``` 

* Verify at [GCP Cloud Console - Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts) that the service account have been created. Now export your GCP `credentials.json` content with `cat` command:
  ```bash
  ls -la *.json
  export GOOGLE_CREDENTIALS=$(cat ./k8c-cluster-provisioner-sa-key.json)
  ```

* Test if your environment variable contains the json key
  ```bash
  echo $GOOGLE_CREDENTIALS
  ```
  Output
  ```text
  { "type": "service_account", "project_id": "YOUR PROJECT", "private_key_id": "..." }
  ```

* Jump back to k1_fundamentals dir
  ```bash
  cd -
  ```

Jump > [**Home**](../README.md) | Previous > [**Setup**](../00_setup/README.md) | Next > [**Cloud Infra Setup using Terraform**](../02_initial-cloud-infra-with-terraform/README.md)