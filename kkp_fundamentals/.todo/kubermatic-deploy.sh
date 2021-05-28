#!/usr/bin/env bash
# Kubermatic Deployment script based on helm3
set -euo pipefail

if [[ $# -lt 1 ]] || [[ "$1" == "--help" ]]; then
  echo "Usage: $(basename \"$0\") (master|seed) path/to/VALUES_AND_CONFIG_FILES path/to/CHART_FOLDER (monitoring|logging|kubermatic|kubermatic-deployment-only)"
  exit 1
fi

DEPLOY_TYPE="$1"
if [[ "$DEPLOY_TYPE" = master ]]; then
  MASTER_FLAG="--set=kubermatic.isMaster=true"
elif [[ "$DEPLOY_TYPE" = seed ]]; then
  MASTER_FLAG="--set=kubermatic.isMaster=false"
else
  echo "invalid deploy type, expected (master|seed), got $DEPLOY_TYPE"
fi

VALUES_AND_CONFIG_FILES=$(realpath "$2")
VALUES_FILE=$VALUES_AND_CONFIG_FILES/values.yaml
if [[ ! -d "$VALUES_AND_CONFIG_FILES" ]]; then
    echo "$(date -Is)" "VALUES_AND_CONFIG_FILES not found! $VALUES_AND_CONFIG_FILES"
    exit 1
fi
if [[ ! -f "$VALUES_FILE" ]]; then
    echo -e "$(date -Is)" "'values.yaml' in folder not found! \nCONTENT $VALUES_AND_CONFIG_FILES:\n`ls -l $VALUES_AND_CONFIG_FILES`"
    exit 1
fi
CHART_FOLDER=$(realpath "$3")
if [[ ! -d "$CHART_FOLDER" ]]; then
    echo "$(date -Is)" "CHART_FOLDER not found! $CHART_FOLDER"
    exit 1
fi
### verification is checked in case expresion
DEPLOY_STACK="$4"

DEPLOY_CERTMANAGER=true
DEPLOY_MINIO=true
DEPLOY_ALERTMANAGER=true
#CANARY_DEPLOYMENT=true
RESTART_POD_PRESETS=true

#verify Helm3
[[ $(helm version --short) =~ ^v3.*$ ]] && echo "helm3 detected!" || (echo "This script requires helm3! Please install helm3: https://helm.sh/docs/intro/install" && exit 1)

function deploy {
  local name="$1"
  local namespace="$2"
  local path="$CHART_FOLDER/$3"
  local timeout="${4:-300s}"

  if [[ ! -d "$path" ]]; then
    echo "chart not found! $path"
    exit 1
  fi
  TEST_NAME="[Helm] Deploy chart $name"

  if [[ -v CANARY_DEPLOYMENT ]]; then
    inital_revision="$(helm history $name --output=json | jq '.Releases[0].Revision')"
  fi

  echo "$(date -Is)" "Upgrading $namespace ..."
  kubectl create namespace "$namespace" || true
  if [[ -d $VALUES_AND_CONFIG_FILES/pernamespace ]]; then
    kubectl apply -n "$namespace" -f $VALUES_AND_CONFIG_FILES/pernamespace
  fi

  helm upgrade --install --wait --timeout $timeout $MASTER_FLAG --values "$VALUES_FILE" --namespace "$namespace" "$name" "$path"

  if [[ -v CANARY_DEPLOYMENT ]]; then
    TEST_NAME="[Helm] Rollback chart $name"
    echo "$(date -Is)" "Rolling back $name to revision $inital_revision as this was only a canary deployment"
    helm rollback --wait --timeout "$timeout" "$name" "$inital_revision"
  fi

  if [[ -d $VALUES_AND_CONFIG_FILES/pernamespace ]] && [[ -v RESTART_POD_PRESETS ]]; then
      echo "$(date -Is)" "Restart deployment, daemonsets in: $namespace..."
      kubectl  -n $namespace get deploy -o name | xargs -L1 kubectl -n $namespace rollout restart || echo "no deployment found!"
      kubectl  -n $namespace get ds -o name | xargs -L1 kubectl -n $namespace  rollout restart || echo "no daemonset found!"
  fi
  unset TEST_NAME
}

function deployKubermatic() {
    echo "$(date -Is)" "Deploying the CRD's..."
    kubectl apply -f "$CHART_FOLDER/kubermatic/crd/"

    deploy kubermatic-operator kubermatic kubermatic-operator/

    echo "$(date -Is)" "Apply the Kubermatic config files..."
    #skip .yaml files with where no apiVersion is specified like the values.yaml
    grep -l 'apiVersion' $VALUES_AND_CONFIG_FILES/*.yaml | xargs -L1 kubectl apply -f
}

echo "$(date -Is)" "Deploying $DEPLOY_STACK stack..."
case "$DEPLOY_STACK" in
  monitoring)
    deploy      node-exporter monitoring monitoring/node-exporter/
    deploy      kube-state-metrics monitoring monitoring/kube-state-metrics/
    deploy      grafana monitoring monitoring/grafana/
    deploy      blackbox-exporter monitoring monitoring/blackbox-exporter/
    if [[ -v DEPLOY_ALERTMANAGER ]]; then
      deploy    alertmanager monitoring monitoring/alertmanager/
    fi
    deploy      prometheus monitoring monitoring/prometheus/ 900s
    ;;

  logging)
    deploy      elasticsearch logging logging/elasticsearch/
    deploy      fluentbit logging logging/fluentbit/
    deploy      kibana logging logging/kibana/
    ;;

  kubermatic)
    if [[ "$1" == master ]]; then
      deploy nginx-ingress-controller nginx-ingress-controller nginx-ingress-controller/

      if [[ -v DEPLOY_CERTMANAGER ]]; then
        #### CERT-MANAGER
        kubectl apply -f "$CHART_FOLDER/cert-manager/crd"
        deploy    cert-manager cert-manager cert-manager/
      fi
      deploy    oauth oauth oauth/

      # We might have not configured IAP which results in nothing being deployed. This triggers https://github.com/helm/helm/issues/4295 and marks this as failed
      # We hack around this by grepping for a string that is mandatory in the values file of IAP
      # to determine if its configured, because am empty chart leads to Helm doing weird things
      if grep -q discovery_url "$VALUES_FILE"; then
        deploy iap iap iap/
      else
        echo "$(date -Is)" "Skipping IAP deployment because discovery_url is unset in values file"
      fi
    fi

    # CI has its own Minio deployment as a proxy for GCS, so we do not install the default Helm chart here.
    if [[ -v DEPLOY_MINIO ]]; then
      deploy    minio minio minio/
      deploy    s3-exporter kube-system s3-exporter/
    fi
    deployKubermatic
    ;;

  kubermatic-deployment-only)
    deployKubermatic
    ;;
  *)
    echo "error: no DEPLOY_STACK defined"
esac
