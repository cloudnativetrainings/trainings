# Credential stuff

```bash
export PROJECT_ID=$(gcloud projects list --format json | jq '.[].projectId' | tr -d \")
export SA_NAME=kkp-admin-training

gcloud iam service-accounts create $SA_NAME --display-name="$SA_NAME"

export SA_EMAIL=$(gcloud iam service-accounts list --format=json --filter="display_name=$SA_NAME" | jq '.[].email' | tr -d \")


# create policy binding
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role='roles/compute.admin'
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role='roles/iam.serviceAccountUser'
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role='roles/viewer'

# get serviceaccount keys
gcloud iam service-accounts keys create --iam-account $SA_EMAIL key.json

# set ENV
export GOOGLE_CREDENTIALS=$(cat ./key.json)
```
