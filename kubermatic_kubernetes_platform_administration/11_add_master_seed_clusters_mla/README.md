# Monitoring of Master and Seed Clusters

In this lab you will install the MLA stack for the Master/Seed Cluster. The documentation for doing this can be found [here](https://docs.kubermatic.com/kubermatic/v2.26/tutorials-howtos/monitoring-logging-alerting/user-cluster/admin-guide/).

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
    - /etc/prometheus/rules/kubermatic-seed-*.yaml
    - /etc/prometheus/rules/managed-*.yaml

alertmanager:
  host: alertmanager.<DOMAIN>

grafana:
  user: <GRAFANA-USERNAME>
  password: <GRAFANA-PASSWORD>
  provisioning:
    configuration:
      disable_login_form: false

loki:
  persistence:
    size: "100Gi"
```

Apply your changes

```bash
# run the installer again
kubermatic-installer --kubeconfig ~/.kube/config \
 --charts-directory ~/kkp/charts deploy seed-mla \
 --config ~/kkp/kubermatic.yaml \
 --helm-values ~/kkp/values.yaml

# verify
kubectl -n monitoring get pods
kubectl -n logging get pods
```

## Expose Grafana, Prometheus and AlertManager

Additionally you have to make those Services available from the outside. Add the following to the file `values.yaml` in the section `dex.clients`. Mind the missing fields.

```yaml
- id: grafana
  name: Grafana
  secret: # created via `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
  RedirectURIs:
    - https://grafana.<DOMAIN>/oauth/callback

- id: prometheus
  name: Prometheus
  secret: # created via `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
  RedirectURIs:
    - "https://prometheus.<DOMAIN>/oauth/callback"

- id: alertmanager
  name: Alertmanager
  secret: # created via `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
  RedirectURIs:
    - "https://alertmanager.<DOMAIN>/oauth/callback"
```

Apply your changes

```bash
# deploy the oauth helm chart
helm --namespace oauth upgrade --install --wait --atomic \
  --values ~/kkp/values.yaml \
  oauth ~/kkp/charts/oauth/
```

Add the following to the file `values.yaml` on root level. Note that the fields `client_secret` has to match the field `dex.clients[*].secret`.

```yaml
iap:
  deployments:
    grafana:
      name: grafana
      ingress:
        host: grafana.<DOMAIN>
      upstream_service: grafana.monitoring.svc.cluster.local
      upstream_port: 3000
      client_id: grafana
      client_secret: # has to match the field `dex.clients[grafana].secret`
      encryption_key: # created via `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
      config:
        scope: "groups openid email"
    prometheus:
      name: prometheus
      ingress:
        host: prometheus.<DOMAIN>
      upstream_service: prometheus.monitoring.svc.cluster.local
      upstream_port: 9090
      client_id: prometheus
      client_secret: <SECRET> # <= has to match dex.clients[prometheus].secret
      encryption_key: # create via `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
      config:
        scope: "groups openid email"
    alertmanager:
      name: alertmanager
      ingress:
        host: alertmanager.<DOMAIN>
      upstream_service: alertmanager.monitoring.svc.cluster.local
      upstream_port: 9093
      client_id: alertmanager
      client_secret: <SECRET> # <= has to match dex.clients[alertmanager].secret
      encryption_key: # create via `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
      config:
        scope: "groups openid email"
```

<!-- DID NOT WORK... -->

Apply your changes

```bash
# create the iap namespace
kubectl create ns iap

# deploy the oauth helm chart
helm --namespace iap upgrade --install --wait --atomic \
  --values ~/kkp/values.yaml \
  iap ~/kkp/charts/iap/

# verify
kubectl -n iap get pods
kubectl -n iap get certificates
```

## Add Link to KKP Side Panel

1. Open the `Admin Panel`
1. Select the Item `Interface` in the Side Panel
1. Add a custom link
   1. With the Label `Grafana`
   1. With the URL `https://grafana.<DOMAIN>`
   1. Note the Icon will be guessed by KKP via the URL
