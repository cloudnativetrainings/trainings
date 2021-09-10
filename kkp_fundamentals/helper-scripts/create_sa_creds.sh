#!/bin/sh

sa_exists() {
    [ `gcloud iam service-accounts list --format="value(email)" \
    --filter="email='$1@$GCP_PROJECT_ID.iam.gserviceaccount.com'" \
    | wc -l` -eq 1 ]
    return $?
}

create_sa() {
    gcloud iam service-accounts create $1
}

add_policy_binding() {
    gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member serviceAccount:$GCP_SERVICE_ACCOUNT_ID \
    --role="$1"
}

create_key_file() {
    gcloud iam service-accounts keys create \
    --iam-account $GCP_SERVICE_ACCOUNT_ID \
    $1
}

main () {
    SA_NAME=$1
    if [ -z "$1" ]; then
        SA_NAME=k1-service-account
    fi

    if [ -z "$GCP_PROJECT_ID" ]; then
        echo "Please set GCP_PROJECT_ID environment variable"
        exit 1
    fi

    echo $SA_NAME

    GCP_SERVICE_ACCOUNT_ID=$SA_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com

    if ! sa_exists $SA_NAME; then
        create_sa k1-service-account
    fi

    add_policy_binding 'roles/compute.admin'
    add_policy_binding 'roles/iam.serviceAccountUser' 
    add_policy_binding 'roles/viewer'
    add_policy_binding 'roles/storage.admin'

    create_key_file k8c-cluster-provisioner-sa-key.json
}

main "$@"