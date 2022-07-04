

# monitoring

<!-- TODO student-01 -->

## add to values.yaml

```yaml
  prometheus:
    host: prometheus.kubermatic.student-01-kkp-admin-training.loodse.training
    storageSize: '250Gi'
    tsdb:
      retentionTime: '30d'
    ruleFiles:
    - /etc/prometheus/rules/general-*.yaml
    - /etc/prometheus/rules/kubermatic-master-*.yaml
    - /etc/prometheus/rules/managed-*.yaml
  
  alertmanager:
    host: alertmanager.kubermatic.student-01-kkp-admin-training.loodse.training
  
  grafana:
    user: admin
    password: adm1n
    provisioning:
      configuration:
        disable_login_form: false  
```


```
kubectl create ns monitoring
helm --namespace monitoring upgrade --install --wait --values ~/kkp/values.yaml prometheus ~/kkp/charts/monitoring/prometheus/
helm --namespace monitoring upgrade --install --wait --values ~/kkp/values.yaml alertmanager ~/kkp/charts/monitoring/alertmanager/
helm --namespace monitoring upgrade --install --wait --values ~/kkp/values.yaml node-exporter ~/kkp/charts/monitoring/node-exporter/
helm --namespace monitoring upgrade --install --wait --values ~/kkp/values.yaml kube-state-metrics ~/kkp/charts/monitoring/kube-state-metrics/
helm --namespace monitoring upgrade --install --wait --values ~/kkp/values.yaml grafana ~/kkp/charts/monitoring/grafana/
helm --namespace monitoring upgrade --install --wait --values ~/kkp/values.yaml karma ~/kkp/charts/monitoring/karma/
helm --namespace monitoring upgrade --install --wait --values ~/kkp/values.yaml blackbox-exporter ~/kkp/charts/monitoring/blackbox-exporter/
```

## logging

```
kubectl create ns logging

helm dependency update ~/kkp/charts/logging/promtail/
helm dependency update ~/kkp/charts/logging/loki/

helm --namespace logging upgrade --install --wait --values ~/kkp/values.yaml promtail ~/kkp/charts/logging/promtail/
helm --namespace logging upgrade --install --wait --values ~/kkp/values.yaml loki ~/kkp/charts/logging/loki/
```


<!-- TODO make DNS name and project name and email env vars and use them all the time -->

# making it available

values.yaml
=> iap
=> dex

## apply iap

kubectl create ns iap
helm --namespace iap upgrade --install --wait --values ~/kkp/values.yaml iap ~/kkp/charts/iap/

## apply dex

kubermatic-installer --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml



# loki

{app="etcd"}


# nice icons

via adminpanel 
do not add image!!!

https://student-01-kkp-admin-training.loodse.training/settings/interface


<!-- TODO also expose alertmanager and prometheus -->

<!-- TODO envsubst everywhere -->

<!-- # TODO remove copy kubeonfing towards .kube folder - it is done via envvar -->

<!-- TODO get rid of grafana password -->

