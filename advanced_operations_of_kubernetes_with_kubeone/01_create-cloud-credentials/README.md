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
  export GCP_SERVICE_ACCOUNT_ID=$(gcloud iam service-accounts list --format='value(email)' --filter='email~k1-service-account.*')
  # e.g.: k1-service-account@student-XX-project.iam.gserviceaccount.com

  # for avoiding problem with Google Cloud Shell on reconnects we persist this value also into our ~/.bashrc rile
  echo "export GCP_SERVICE_ACCOUNT_ID=$GCP_SERVICE_ACCOUNT_ID" >> ~/.bashrc


  ```

* Create policy binding
  ```bash
  gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/compute.admin'
  gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/iam.serviceAccountUser'
  gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/viewer'
  gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID --role='roles/storage.admin'
  ```

<!-- TODO training is not set yet, where does it happen??? -->

* Create a new json key for your service account
  ```bash
  mkdir -p ./.secrets && cd ./.secrets
  gcloud iam service-accounts keys create --iam-account $GCP_SERVICE_ACCOUNT_ID k8c-cluster-provisioner-sa-key.json
  ``` 

* Verify at [GCP Cloud Console - Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts) that the service account have been created. Now export your GCP `credentials.json` content with `cat` command:
  ```bash
  ls -la *.json
  export GOOGLE_CREDENTIALS=$(cat ./k8c-cluster-provisioner-sa-key.json)

  # for avoiding problem with Google Cloud Shell on reconnects we persist this value also into our ~/.bashrc rile
  echo "export GOOGLE_CREDENTIALS='$(cat ./k8c-cluster-provisioner-sa-key.json)'" >> ~/.bashrc

  ```

* Test if your environment variable contains the json key
  ```bash
  echo $GOOGLE_CREDENTIALS | jq .
  ```
  Output
  ```text
  { "type": "service_account", "project_id": "YOUR PROJECT", "private_key_id": "..." }
  ```

* Jump back to training dir
  ```bash
  cd $TRAINING_DIR
  ```

Jump > [**Home**](../README.md) | Previous > [**Setup**](../00_setup/README.md) | Next > [**Cloud Infra Setup using Terraform**](../02_initial-cloud-infra-with-terraform/README.md)

