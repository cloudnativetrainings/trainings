#!/usr/bin/env bash

# This script can be used to transform a kubeconfig file with
# ephemeral credentials (e.g. for EKS clusters with aws-iam-authenticator
# or GKE clusters) into a kubeconfig with static credentials.
# For this is creates a service account in each cluster, adds
# a new user with the account's token and then updates the
# context to use the new user.

set -euo pipefail

if [ "$#" -lt 1 ] || [ "${1}" == "--help" ]; then
  echo "Usage: $(basename $0) <kubeconfig file>"
  exit 0
fi

if ! [ -x "$(command -v jq)" ]; then
  echo "Please install jq(1) to parse JSON."
  echo "See https://stedolan.github.io/jq"
  exit 1
fi

if ! [ -x "$(command -v yq)" ]; then
  echo "Please install yq(1) to parse/write YAML."
  echo "See https://github.com/mikefarah/yq"
  exit 1
fi

kubeconfig="$1"
accountname="kubermatic-seed-account"
namespace="kubermatic"
tmpconfig="$(mktemp kubermatic.XXXX)"
swapfile="$(mktemp kubermatic.XXXX)"

clean_up () {
    echo "> clean_up"
    rm -rf $tmpconfig
    rm -rf $swapfile
}
trap clean_up EXIT

# configure kubeconfig to JSON
yq read -j "$kubeconfig" > "$tmpconfig"

# find all clusters
clusters="$(jq -r '.clusters[].name' "$tmpconfig")"

for cluster in $clusters; do
  echo "Cluster: $cluster"

  # find the first context for this cluster
  context="$(jq -r "first(.contexts[] | select(.context.cluster == \"$cluster\")) | .name" "$tmpconfig")"
  if [ -z "$context" ]; then
    echo " ! warning, no matching context found"
    echo ""
    continue
  fi

  echo " > context: $context"

  # create the service account
  echo " > creating service account $accountname ..."
  kubectl --kubeconfig "$kubeconfig" --context "$context" apply -f - > /dev/null <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $accountname
  namespace: $namespace
YAML

  # give admin permissions
  clusterrole="$accountname-cluster-role"
  echo " > assigning cluster role $clusterrole ..."
  kubectl --kubeconfig "$kubeconfig" --context "$context" apply -f - > /dev/null <<YAML
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: $clusterrole
subjects:
- kind: ServiceAccount
  name: $accountname
  namespace: $namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
YAML

  # read auth token
  echo " > reading auth token..."
  servicename="$(kubectl --kubeconfig "$kubeconfig" --context "$context" get serviceaccount "$accountname" -n $namespace -o jsonpath='{.secrets[0].name}')"
  token="$(kubectl --kubeconfig "$kubeconfig" --context "$context" get secret "$servicename" -n $namespace -o jsonpath='{.data.token}' | base64 -d)"

  # update kubeconfig
  username="$cluster-kubermatic-service-account"
  echo " > adding user $username ..."

  if [ -z "$(jq ".users[] | select(.name == \"$username\")" "$tmpconfig")" ]; then
    # account does not yet exist
    jq ".users |= . + [{\"name\":\"$username\",\"user\":{\"token\":\"\"}}]" "$tmpconfig" > "$swapfile"
    cp "$swapfile" "$tmpconfig"
  fi

  # insert token into config
  jq "(.users[] | select(.name == \"$username\") | .user.token) |= \"$token\"" "$tmpconfig" > "$swapfile"
  cp "$swapfile" "$tmpconfig"

  # update context username
  echo " > updating cluster context..."
  jq "(.contexts[] | select(.name == \"$context\") | .context.user) |= \"$username\"" "$tmpconfig" > "$swapfile"
  cp "$swapfile" "$tmpconfig"

  echo " > kubeconfig updated"
  echo ""
done

# JSON to YAML
yq read "$tmpconfig" > "$kubeconfig"
