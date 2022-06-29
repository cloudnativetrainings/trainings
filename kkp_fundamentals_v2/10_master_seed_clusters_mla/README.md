<!-- TODO ensure that charts kubermatic and values are the same like in master -->


# add to values.yaml

```yaml
  prometheus:
    host: prometheus.kubermatic.student-01-kkp-admin-training.loodse.training
    storageSize: '250Gi'
    tsdb:
      retentionTime: '30d'
    # only load the KKP-master alerts, as this cluster is not a shared master/seed
    ruleFiles:
    - /etc/prometheus/rules/general-*.yaml
    # - /etc/prometheus/rules/kubermatic-master-*.yaml
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

kubectl create ns monitoring

```
helm --namespace monitoring upgrade --install --wait --values ~/seed/kkp/values.yaml prometheus ~/seed/kkp/charts/monitoring/prometheus/
helm --namespace monitoring upgrade --install --wait --values ~/seed/kkp/values.yaml alertmanager ~/seed/kkp/charts/monitoring/alertmanager/
helm --namespace monitoring upgrade --install --wait --values ~/seed/kkp/values.yaml node-exporter ~/seed/kkp/charts/monitoring/node-exporter/
helm --namespace monitoring upgrade --install --wait --values ~/seed/kkp/values.yaml kube-state-metrics ~/seed/kkp/charts/monitoring/kube-state-metrics/
helm --namespace monitoring upgrade --install --wait --values ~/seed/kkp/values.yaml grafana ~/seed/kkp/charts/monitoring/grafana/
helm --namespace monitoring upgrade --install --wait --values ~/seed/kkp/values.yaml karma ~/seed/kkp/charts/monitoring/karma/
helm --namespace monitoring upgrade --install --wait --values ~/seed/kkp/values.yaml blackbox-exporter ~/seed/kkp/charts/monitoring/blackbox-exporter/
```