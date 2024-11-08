# Monitoring of Master and Seed Clusters

## Configure Monitoring Stack

Add the following to the file `values.yaml` on root level. Take care about the Domain.

```yaml
prometheus:
  host: prometheus.<DOMAIN>
  storageSize: "250Gi"
  tsdb:
    retentionTime: "30d"
  ruleFiles:
    - /etc/prometheus/rules/general-*.yaml
    - /etc/prometheus/rules/kubermatic-master-*.yaml
    - /etc/prometheus/rules/managed-*.yaml

alertmanager:
  host: alertmanager.<DOMAIN>

grafana:
  provisioning:
    datasources:
      prometheusServices:
        - prometheus
      lokiServices:
        - loki
    configuration:
      auto_assign_org_role: Editor
      viewers_can_edit: true
      root_url: https://grafana.<DOMAIN>
```

## Apply the Monitoring Stack

```bash
# Create Namespace monitoring
kubectl create ns monitoring

# Apply Monitoring Helm Charts
helm --namespace monitoring upgrade --install --wait --atomic --values ~/kkp/values.yaml prometheus ~/kkp/charts/monitoring/prometheus/
helm --namespace monitoring upgrade --install --wait --atomic --values ~/kkp/values.yaml alertmanager ~/kkp/charts/monitoring/alertmanager/
helm --namespace monitoring upgrade --install --wait --atomic --values ~/kkp/values.yaml node-exporter ~/kkp/charts/monitoring/node-exporter/
helm --namespace monitoring upgrade --install --wait --atomic --values ~/kkp/values.yaml kube-state-metrics ~/kkp/charts/monitoring/kube-state-metrics/
helm --namespace monitoring upgrade --install --wait --atomic --values ~/kkp/values.yaml grafana ~/kkp/charts/monitoring/grafana/
helm --namespace monitoring upgrade --install --wait --atomic --values ~/kkp/values.yaml karma ~/kkp/charts/monitoring/karma/
helm --namespace monitoring upgrade --install --wait --atomic --values ~/kkp/values.yaml blackbox-exporter ~/kkp/charts/monitoring/blackbox-exporter/

# Verify installation
kubectl -n monitoring get pods
```

## Apply the Logging Stack

```bash
# Create Namespace logging
kubectl create ns logging

# Apply Logging Helm Charts
helm dependency update ~/kkp/charts/logging/promtail/
helm dependency update ~/kkp/charts/logging/loki/
helm --namespace logging upgrade --install --wait --atomic --values ~/kkp/values.yaml promtail ~/kkp/charts/logging/promtail/
helm --namespace logging upgrade --install --wait --atomic --values ~/kkp/values.yaml loki ~/kkp/charts/logging/loki/

# Verify installation
kubectl -n logging get pods
```

## Expose Grafana

Additionally you have to make Grafana available from the outside. Add the following to the file `values.yaml` in the section `dex.clients`. Mind the missing fields.

```yaml
- id: grafana
  name: Grafana
  secret: # created via `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
  RedirectURIs:
    - https://grafana.<DOMAIN>/oauth/callback
```

Add the following to the file `values.yaml` on root level. Note that the field `client_secret` has to match the field `dex.clients[grafana].secret`.

```yaml
iap:
  oidc_issuer_url: https://<DOMAIN>/dex
  deployments:
    grafana:
      name: grafana
      client_id: grafana
      client_secret: # has to match the field `dex.clients[grafana].secret`
      encryption_key: # created via `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
      config:
        scope: "groups openid email"
        email_domains:
          - "*"
        skip_auth_regex:
          - "/api/health"
        pass_user_headers: true
      upstream_service: grafana.monitoring.svc.cluster.local
      upstream_port: 3000
      ingress:
        host: "grafana.<DOMAIN>"
        annotations: {}
```

```bash
# upgrade oauth chart
helm --namespace oauth upgrade --install --wait --atomic --values ~/kkp/values.yaml oauth ~/kkp/charts/oauth

# create namespace iap
kubectl create ns iap

# install iap chart
helm --namespace iap upgrade --install --wait --atomic --values ~/kkp/values.yaml iap ~/kkp/charts/iap
```

## Add Link to KKP Side Panel

1. Open the `Admin Panel`
1. Select the Item `Interface` in the Side Panel
1. Add a custom link
   1. With the Label `Grafana`
   1. With the URL `https://grafana.<DOMAIN>`
   1. Note the Icon will be guessed by KKP via the URL
