# Monitoring, Logging & Alerting (MLA) Stack setup on User Cluster


## Install User Cluster MLA stack

Clone the GitHub MLA repository
```bash
git clone https://github.com/kubermatic/mla.git
```

Create MLA secrets
```bash
cd mla
helm --namespace mla upgrade --atomic --create-namespace --install mla-secrets charts/mla-secrets --values config/mla-secrets/values.yaml
```

Deploy Seed Cluster Components
```bash
./hack/deploy-seed.sh
```

Navigate to kkp-setup folder
```bash
cd $TRAINING_DIR/src/kkp-setup/
```

Add the below DEX configuratio into the values.yaml
```yaml
dex:
  clients:
  - id: user-mla-grafana
    name: user-mla-grafana
    # Replace the `TODO-RAMDOM-USER-GRAFANA-SECRET` with random secret generated using `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
    secret: TODO-RAMDOM-USER-GRAFANA-SECRET
    RedirectURIs:
    - https://grafana.kubermatic.kubermatic.TODO-STUDENT-DNS.loodse.training/oauth/callback    
  - id: user-mla-alertmanager  
    name: user-mla-alertmanager
    # Replace the `TODO-RAMDOM-USER-AM-SECRET` with random secret generated using `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
    secret: TODO-RAMDOM-USER-AM-SECRET
    RedirectURIs:
    - https://alertmanager.kubermatic.kubermatic.TODO-STUDENT-DNS.loodse.training/oauth/callback

```

REPLACE the `TODO` placeholders related the DEX configuration in the values.yaml
```bash
sed -i 's/TODO-STUDENT-DNS/$DNS_ZONE/g' ./values.yaml
export RAMDOM-USER-GRAFANA-SECRET=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32)
sed -i 's/TODO-RAMDOM-USER-GRAFANA-SECRET/'"$RAMDOM-USER-GRAFANA-SECRET"'/g' ./values.yaml
export RAMDOM-USER-AM-SECRET=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32)
sed -i 's/TODO-RAMDOM-USER-AM-SECRET/'"$RAMDOM-USER-AM-SECRET"'/g' ./values.yaml
```

Install/upgrade the `oauth` Helm chart. 
```bash
helm --namespace oauth upgrade --install --create-namespace --wait --values values.yaml oauth ./releases/v2.18.2/charts/oauth/
```

Add config/iap/values.yaml inside MLA repository
```yaml
iap:
  oidc_issuer_url: https://kubermatic.TODO-STUDENT-DNS.loodse.training/dex
  deployments:
    user-mla-grafana:
      name: user-mla-grafana
      replicas: 1
      ingress:
        host: grafana.kubermatic.kubermatic.TODO-STUDENT-DNS.loodse.training
      upstream_service: grafana.mla.svc.cluster.local
      upstream_port: 80
      #Should match to the `id` value from DEX configuration
      client_id: user-mla-grafana
      # Replace the `TODO-RAMDOM-USER-GRAFANA-SECRET-FROM-DEX` with `secret` value from DEX configuration
      client_secret: TODO-RAMDOM-USER-GRAFANA-SECRET-FROM-DEX
      # Replace the `TODO-RAMDOM-USER-GRAFANA-KEY` with random key generated using `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
      encryption_key: TODO-RAMDOM-USER-GRAFANA-KEY
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
    user-mla-alertmanager:
      name: user-mla-alertmanager
      replicas: 1
      ingress:
        host: alertmanager.kubermatic.kubermatic.TODO-STUDENT-DNS.loodse.training
      upstream_service: alertmanager-proxy.mla.svc.cluster.local
      upstream_port: 8080
      #Should match to the `id` value from DEX configuration
      client_id: user-mla-alertmanager
      # Replace the `TODO-RAMDOM-USER-AM-SECRET-FROM-DEX` with `secret` value from DEX configuration
      client_secret: TODO-RAMDOM-USER-AM-SECRET-FROM-DEX
      # Replace the `TODO-RAMDOM-USER-GRAFANA-KEY` with random key generated using `cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`
      encryption_key: TODO-RAMDOM-USER-AM-KEY
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
```

REPLACE the `TODO` placeholders related the IAP configuration in the config/iap/values.yaml inside mla repository
```bash
sed -i 's/TODO-STUDENT-DNS/$DNS_ZONE/g' ./values.yaml
sed -i 's/TODO-RAMDOM-USER-GRAFANA-SECRET-FROM-DEX/'"$RAMDOM-USER-GRAFANA-SECRET"'/g' ./values.yaml
sed -i 's/TODO-RAMDOM-USER-AM-SECRET-FROM-DEX/'"$RAMDOM-USER-AM-SECRET"'/g' ./values.yaml
export RAMDOM-USER-GRAFANA-KEY=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32)
sed -i 's/TODO-RAMDOM-USER-GRAFANA-KEY/'"$RAMDOM-USER-GRAFANA-KEY"'/g' ./values.yaml
export RAMDOM-USER-AM-KEY=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32)
sed -i 's/TODO-RAMDOM-USER-AM-KEY/'"$RAMDOM-USER-AM-KEY"'/g' ./values.yaml
```

Install/upgrade the `iap` Helm chart. 
```bash
cd -
helm --namespace mla upgrade --atomic --create-namespace --install iap $TRAINING_DIR/src/kkp-setup/releases/v2.18.2/charts/iap --values config/iap/values.yaml
```

Enabling MLA Feature in KKP Configuration
* Update the kubermatic.yaml to enable MLA feature in KKP configuration
  ```yaml
  apiVersion: operator.kubermatic.io/v1alpha1
  kind: KubermaticConfiguration
  metadata:
    name: kubermatic
    namespace: kubermatic
  spec:
    # Enabling MLA Feature in KKP Configuration
    featureGates:
      UserClusterMLA:
        enabled: true
  ```

* Apply the changes
  ```bash
  cd $TRAINING_DIR/src/kkp-setup/
  kubectl apply -f kubermatic.yaml
  ```

Enabling MLA Stack in a Seed
* Update the seed.europe-west.yaml to enable MLA stack in a seed
  ```yaml
  apiVersion: kubermatic.k8s.io/v1
  kind: Seed
  metadata:
    name: europe-west3-c
    namespace: kubermatic
  spec:
    # Enabling MLA Stack in a Seed
    mla:
      user_cluster_mla_enabled: true
  ```
 
* Apply the changes
  ```bash
  kubectl apply -f seed.europe-west.yaml
  ```

Admin Panel Configuration

Follow step as documented [here](https://docs.kubermatic.com/kubermatic/master/guides/monitoring_logging_alerting/user_cluster/admin_guide/#admin-panel-configuration)

Addons Configuration

Follow step as documented [here](https://docs.kubermatic.com/kubermatic/master/guides/monitoring_logging_alerting/user_cluster/admin_guide/#addons-configuration)

Create DNS Records 
* Find the Address for Grafana and Alertmanager
  ```bash
  kubectl -n mla get ing
  ```

* Set the variable 
  ```bash
  export USERMLA_GRAFANA_DNS_IP=XX.XX.XX.XX
  export USERMLA_ALERTMANAGER_DNS_IP=XX.XX.XX.XX
  ```

* Add the DNS entries for `grafana.kubermatic.kubermatic.$DNS_ZONE.loodse.training` and `grafana.kubermatic.kubermatic.$DNS_ZONE.loodse.training` as follows:
  ```bash
  gcloud dns record-sets transaction add --zone=$DNS_ZONE --name="grafana.kubermatic.kubermatic.$DNS_ZONE.loodse.training" --ttl 300 --type A  $USERMLA_GRAFANA_DNS_IP
  gcloud dns record-sets transaction add --zone=$DNS_ZONE --name="alertmanager.kubermatic.kubermatic.$DNS_ZONE.loodse.training" --ttl 300 --type A  $USERMLA_ALERTMANAGER_DNS_IP
  ```


Verify the setup

**Grafana** --> https://grafana.kubermatic.kubermatic.$DNS_ZONE.loodse.training

**AlertManager** --> https://alertmanager.kubermatic.kubermatic.$DNS_ZONE.loodse.training


## Uninstallation of User Cluster MLA stack
* Disable the User Cluster MLA feature in Seed configuration
* Remove the User Cluster MLA components from Seed
* Remove the User Cluster MLA data from Seed

Disabling the User Cluster MLA in Seed Configuration
* Update the seed.europe-west.yaml 
  ```yaml
  apiVersion: kubermatic.k8s.io/v1
  kind: Seed
  metadata:
    name: europe-west3-c
    namespace: kubermatic
  spec:
    mla:
      user_cluster_mla_enabled: false #<<CHANGE
  ```

* Apply the change to seed cluster
  ```bash
  kubectl -n kubermatic apply -f seed.europe-west.yaml
  ```

Removing the User Cluster MLA Components

In order to uninstall the user cluster MLA stack components from a Seed cluster, first disable it in the Seed Custom Resource / API object as described in the previous section. After that, you can safely remove the resources in the mla namespace of the Seed Cluster.

To Deep Dive, look into official [User Cluster MLA Stack](https://docs.kubermatic.com/kubermatic/master/tutorials_howtos/monitoring_logging_alerting/user_cluster/user_guide/) documentation

Jump > [Home](../README.md) | Previous > [Master/Seed CLuster MLA Stack Setup](../08-deploy-master-cluster-mla/README.md)