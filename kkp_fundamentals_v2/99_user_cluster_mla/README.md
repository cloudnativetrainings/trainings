
# get user mla

git clone https://github.com/kubermatic/mla user-mla

# update deps

<!-- TODO create bugs in docs for this fucking crap -->
helm dependency update ~/user-mla/charts/alertmanager-proxy/
helm dependency update ~/user-mla/charts/consul/
helm dependency update ~/user-mla/charts/cortex/
helm dependency update ~/user-mla/charts/grafana/
helm dependency update ~/user-mla/charts/loki-distributed/
helm dependency update ~/user-mla/charts/minio/
helm dependency update ~/user-mla/charts/minio-lifecycle-mgr/
helm dependency update ~/user-mla/charts/mla-secrets/

# apply some secrets

kubectl create ns mla

helm --namespace mla upgrade --atomic --install mla-secrets ~/user-mla/charts/mla-secrets --values ~/user-mla/config/mla-secrets/values.yaml

# install crap

<!-- ./hack/deploy-seed.sh -->

helm --namespace mla upgrade --atomic --install minio-lifecycle-mgr ~/user-mla/charts/minio-lifecycle-mgr --values ~/user-mla/config/minio-lifecycle-mgr/values.yaml
helm --namespace mla upgrade --atomic --install grafana ~/user-mla/charts/grafana --values ~/user-mla/config/grafana/values.yaml

kubectl apply -f ~/user-mla/dashboards/

helm --namespace mla upgrade --atomic --install consul ~/user-mla/charts/consul --values ~/user-mla/config/consul/values.yaml --set consul.server.storageClass=kubermatic-fast
<!-- BUG: fix PVC storageClassName: kubermatic-fast -->

kubectl create -n mla configmap cortex-runtime-config --from-file=config/cortex/runtime-config.yaml || true

helm --namespace mla upgrade --atomic --install cortex ~/user-mla/charts/cortex --values ~/user-mla/config/cortex/values.yaml --timeout 1200s
helm --namespace mla upgrade --atomic --install loki-distributed ~/user-mla/charts/loki-distributed --values ~/user-mla/config/loki/values.yaml --timeout 600s
helm --namespace mla upgrade --atomic --install alertmanager-proxy ~/user-mla/charts/alertmanager-proxy

# configure

iap deployment
```yaml
mla-grafana:
  name: mla-grafana
  replicas: 1
  client_id: mla-grafana
  client_secret: 5F0Dbjw961cIk6nga11ZWH6gBeMf8F83
  encryption_key: 7XyAzfRhT5dExHMxErVjqtkku4orZuLh
  config:
    scope: "groups openid email"
    email_domains:
      - '*'
    ## do not route health endpoint through the proxy
    skip_auth_regex:
      - '/api/health'
    ## auto-register users based on their email address
    ## Grafana is configured to look for the X-Forwarded-Email header
    pass_user_headers: true
  upstream_service: grafana.mla.svc.cluster.local
  upstream_port: 80
  ingress:
    host: "grafana.kubermatic.student-01-kkp-admin-training.loodse.training"
```

dex.clients
```yaml
- id: mla-grafana
  name: mla-grafana
  secret: 5F0Dbjw961cIk6nga11ZWH6gBeMf8F83
  RedirectURIs:
    - https://grafana.kubermatic.student-01-kkp-admin-training.loodse.training/oauth/callback
```

<!-- TODO do via helm -->

kubermatic-installer --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml

# engage in master

kubermatic-configuration
```yaml
apiVersion: kubermatic.k8c.io/v1
kind: KubermaticConfiguration
metadata:
  name: kubermatic
  namespace: kubermatic
spec:
  featureGates:
    UserClusterMLA: true
```

kubectl apply -f ~/kkp/kubermatic.yaml

# engage in seed

```yaml
apiVersion: kubermatic.k8c.io/v1
kind: Seed
metadata:
  name: europe-west3-c
  namespace: kubermatic
spec:
  mla:
    userClusterMLAEnabled: true
```

kubectl apply -f ~/kkp/seed.yaml