#!/usr/bin/env bash

# This script can be used to transform a kubeconfig file with
# ephemeral credentials (e.g. for EKS clusters with aws-iam-authenticator
# or GKE clusters) into a kubeconfig with static credentials.
# For this is creates a service account in each cluster, adds
# a new user with the account's token and then updates the
# context to use the new user.

#set -x

if [[ -z ${PROJECT_NAME} ]]
then
  echo "INPUT: Type PROJECT_NAME (student-XX-project):" && read PROJECT_NAME
fi
# variables
export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=k8c-master

accountname="kubermatic-seed-account"

set -euo pipefail
GET_CMD="gcloud container clusters describe $CLUSTER_NAME --zone $ZONE --project $PROJECT_NAME"

# create the service account
echo " > creating service account $accountname ..."
kubectl apply -f - > /dev/null <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $accountname
  namespace: default
YAML

# give admin permissions
clusterrole="$accountname-cluster-role"
echo " > assigning cluster role $clusterrole ..."
kubectl apply -f - > /dev/null <<YAML
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: $clusterrole
subjects:
- kind: ServiceAccount
  name: $accountname
  namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
YAML

# read auth token
echo " > reading auth token..."
servicename="$(kubectl get serviceaccount "$accountname" -o jsonpath='{.secrets[0].name}')"
token="$(kubectl get secret "$servicename" -o jsonpath='{.data.token}' | base64 -d)"



# update kubeconfig
username="kubermatic-service-account"
echo " > adding user $username ..."

clustername=$CLUSTER_NAME
cat > $clustername.sa.kubeconfig.yaml <<EOF
apiVersion: v1
kind: Config
current-context: $clustername
contexts:
- name: $clustername
  context:
    cluster: $clustername
    user: $username
users:
- name: $username
  user:
    token: $token
clusters:
- name: $clustername
  cluster:
    server: "https://$(eval "$GET_CMD --format='value(endpoint)'")"
    certificate-authority-data: "$(eval "$GET_CMD --format='value(masterAuth.clusterCaCertificate)'")"
EOF
echo " > config user $clustername.sa.kubeconfig.yaml created"
cat $clustername.sa.kubeconfig.yaml