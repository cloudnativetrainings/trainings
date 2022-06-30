#!/bin/bash

set -euxo pipefail

helm upgrade --install --create-namespace --namespace monitoring --wait \
  --values ./values.yaml prometheus charts/monitoring/prometheus 

helm upgrade --install --create-namespace --namespace monitoring --wait \
  --values ./values.yaml alertmanager charts/monitoring/alertmanager

helm upgrade --install --create-namespace --namespace monitoring --wait \
  --values ./values.yaml blackbox-exporter charts/monitoring/blackbox-exporter

helm upgrade --install --create-namespace --namespace monitoring --wait \
  --values ./values.yaml grafana charts/monitoring/grafana

# helm upgrade --install --create-namespace --namespace monitoring --wait \
#   --values ./values.yaml helm-exporter charts/monitoring/helm-exporter

helm upgrade --install --create-namespace --namespace monitoring --wait \
  --values ./values.yaml karma charts/monitoring/karma

helm upgrade --install --create-namespace --namespace monitoring --wait \
  --values ./values.yaml kube-state-metrics charts/monitoring/kube-state-metrics

helm upgrade --install --create-namespace --namespace monitoring --wait \
  --values ./values.yaml node-exporter charts/monitoring/node-exporter
