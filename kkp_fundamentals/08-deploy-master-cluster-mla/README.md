# Monitoring, Logging & Alerting (MLA) Stack setup on Master/Seed Cluster

At this step, you will install set of Helm charts to enable MLA stack on the combined Master / Seed cluster.

More details about this topic is summarized in [this](https://docs.kubermatic.com/kubermatic/master/guides/monitoring_logging_alerting/master_seed/installation/) documentation.

## Extend values.yaml

We will extend the existing `values.yaml` file following content:

```yaml
prometheus:
  host: prometheus.kubermatic.TODO-STUDENT-DNS.loodse.training
  storageSize: '25Gi'
  tsdb:
    retentionTime: '14d'
  ruleFiles:
  - /etc/prometheus/rules/general-*.yaml
  # include both master + seed rules
  - /etc/prometheus/rules/kubermatic-*.yaml
  - /etc/prometheus/rules/managed-*.yaml

alertmanager:
  host: alertmanager.kubermatic.TODO-STUDENT-DNS.loodse.training

grafana:
  user: admin
  password: adm1n
  provisioning:
    configuration:
      disable_login_form: false
```

Edit `values.yaml` and paste the content above.
```bash
cd $TRAINING_DIR/src/kkp-setup/
vim values.yaml
```

Get gcloud DNS_ZONE and set the value of `DNS_ZONE`.
```bash
gcloud dns managed-zones list
export DNS_ZONE=student-XX-xxxx   #WITHOUT loodse.training!
```

Replace TODO-STUDENT-DNS with your DNS.
```bash
sed -i 's/TODO-STUDENT-DNS/'"$DNS_ZONE"'/g' values.yaml
```

## Deploy Monitoring / Alerting Services
Create monitoring namespace
```bash
cd $TRAINING_DIR/src/kkp-setup/
kubectl create ns monitoring
helm --namespace monitoring upgrade --install --wait --values values.yaml prometheus releases/v2.18.2/charts/monitoring/prometheus/
helm --namespace monitoring upgrade --install --wait --values values.yaml alertmanager releases/v2.18.2/charts/monitoring/alertmanager/
helm --namespace monitoring upgrade --install --wait --values values.yaml node-exporter releases/v2.18.2/charts/monitoring/node-exporter/
helm --namespace monitoring upgrade --install --wait --values values.yaml kube-state-metrics releases/v2.18.2/charts/monitoring/kube-state-metrics/
helm --namespace monitoring upgrade --install --wait --values values.yaml grafana releases/v2.18.2/charts/monitoring/grafana/
helm --namespace monitoring upgrade --install --wait --values values.yaml karma releases/v2.18.2/charts/monitoring/karma/
helm --namespace monitoring upgrade --install --wait --values values.yaml blackbox-exporter releases/v2.18.2/charts/monitoring/blackbox-exporter/
```

>**Note**: If any of the helm chart installation step fails, check the specific pods for details. It may also happen that autoscaling will be involved in case that there is not enough capacity on the current nodes (that may take a few minutes).

You can check if all helm charts were installed properly.

```bash
helm list -n monitoring
```

```text
NAME                            NAMESPACE                       REVISION        UPDATED                                 STATUS          CHART                           APP VERSION
alertmanager                    monitoring                      1               2021-08-25 13:54:36.625835968 +0000 UTC deployed        alertmanager-2.0.14             v0.21.0
grafana                         monitoring                      1               2021-08-25 13:56:32.998094947 +0000 UTC deployed        grafana-1.4.11                  7.4.3
karma                           monitoring                      1               2021-08-25 13:56:56.476703054 +0000 UTC deployed        karma-0.0.14                    v0.80
kube-state-metrics              monitoring                      1               2021-08-25 13:56:20.128128157 +0000 UTC deployed        kube-state-metrics-1.0.10       v1.9.7
node-exporter                   monitoring                      1               2021-08-25 13:56:07.372705792 +0000 UTC deployed        node-exporter-1.2.1             v1.1.2
prometheus                      monitoring                      1               2021-08-25 14:11:16.390922955 +0000 UTC deployed        prometheus-2.3.3                v2.25.0
s3-exporter                     kube-system                     1               2021-08-25 13:08:30.580210503 +0000 UTC deployed        s3-exporter-1.1.5               v0.5
```

```bash
kubectl get pod -n monitoring
```

```text
NAME                                 READY   STATUS    RESTARTS   AGE
alertmanager-0                       2/2     Running   0          27m
alertmanager-1                       2/2     Running   0          27m
alertmanager-2                       2/2     Running   0          26m
grafana-7f748d94bb-mxwss             1/1     Running   0          25m
karma-79b9ddf65b-pwglb               1/1     Running   0          25m
kube-state-metrics-c85db6495-xkh28   2/2     Running   0          26m
node-exporter-4j8lz                  2/2     Running   0          26m
node-exporter-6sfg6                  2/2     Running   0          2m52s
node-exporter-dx2pz                  2/2     Running   0          26m
node-exporter-q8pnd                  2/2     Running   0          26m
node-exporter-vcr5q                  2/2     Running   0          26m
prometheus-0                         3/3     Running   0          32m
prometheus-1                         3/3     Running   0          28m
```

## Deploy Logging Services

We can keep the default values for these charts and install them on cluster.

If you want to see default values of all charts, find the `values.yaml` files under `./releases/v2.18.2/charts`.

```bash
cd $TRAINING_DIR/src/kkp-setup/
kubectl create ns logging
helm --namespace logging upgrade --install --wait --values values.yaml promtail releases/v2.18.2/charts/logging/promtail/
helm --namespace logging upgrade --install --wait --values values.yaml loki releases/v2.18.2/charts/logging/loki/
```

You can check if all helm charts were installed properly.

```bash
helm list -n logging
```

```text
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
loki            logging         1               2021-08-25 14:16:56.479501435 +0000 UTC deployed        loki-0.1.1      v2.1.0
promtail        logging         1               2021-08-25 14:11:55.653445933 +0000 UTC deployed        promtail-0.2.0  v2.1.0
```

```bash
kubectl get pod -n logging
```

```text
NAME             READY   STATUS    RESTARTS   AGE
loki-0           1/1     Running   0          6m1s
promtail-4g5cs   1/1     Running   0          11m
promtail-4tx8z   1/1     Running   0          11m
promtail-68bbb   1/1     Running   0          11m
promtail-8f86q   1/1     Running   0          3m8s
promtail-ck8k6   1/1     Running   0          11m
```

## Accessing MLA services

At this point, all of the above services are only accessible inside the cluster. If you want to expose them, take a look DEX and IAP configuration details
at [Security System Services](https://docs.kubermatic.com/kubermatic/v2.20/architecture/concept/kkp-concepts/kkp_security/securing_system_services/) documentation to do it a secure way - integrated with Dex authentication.

If you want to access some services locally, grab the kubeconfig to your local machine (so that you can perform the port-forwarding).

```bash
export KUBECONFIG=path/to/downloaded/kubeconfig
kubectl get svc -n monitoring
kubectl port-forward -n monitoring service/grafana 3000:3000
```

```text
Forwarding from 127.0.0.1:3000 -> 3000
Forwarding from [::1]:3000 -> 3000
```

Now you will be able to access grafana on [localhost:3000](http://localhost:3000/).

Same for any other available service, just use the right name and port.

Jump > [Home](../README.md) | Previous > [Preset](../07-create-preset/README.md) | Next > [User Cluster MLA Stack Setup](../09-user-cluster-mla/README.md)