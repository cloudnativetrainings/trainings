# Enable the Kubernetes Dashboard

In this lab you will enable the Kubernetes Dashboard for User Clusters.

## Changes in `kubermatic.yaml`

### Enable Feature Gates

```yaml
---
spec:
  featureGates:
    OIDCKubeCfgEndpoint: true
    OpenIDAuthPlugin: true
```

## Add issuerRedirectUrl to `auth` section

<!-- TODO verify if needed -->

```yaml
...
spec:
  oauth:
    ...
    issuerRedirectURL: https://<DOMAIN>/api/v1/kubeconfig
```

## Changes in `values.yaml`

Add the OIDC redirect URL section `dex.clients[kubermaticIssuer].RedirectURIs`.

Please verify that `dex.clients[kubermaticIssuer].secret` of the field `values.yaml` matches the field `spec.auth.issuerClientSecret` of the file `kubermatic.yaml`.

```yaml
...
dex:
  clients:
    ...
    - id: kubermaticIssuer
      name: Kubermatic OIDC Issuer
      secret: <SECRET> # <= has to match `spec.auth.issuerClientSecret` of the file `kubermatic.yaml`
      RedirectURIs:
        - https://<DOMAIN>/api/v2/kubeconfig/secret
        - https://<DOMAIN>/api/v2/dashboard/login
        - https://<DOMAIN>/api/v1/kubeconfig  # <= add this
...
```

## Deploy your changes

```bash
# deploy the oauth helm chart
helm --namespace oauth upgrade --install --wait --values ~/kkp/values.yaml oauth ~/kkp/charts/oauth/

# apply the changes in the kkp configuration
kubectl apply -f ~/kkp/kubermatic.yaml

# TODO verify if needed

# kubermatic-installer --kubeconfig ~/.kube/config \
#  --charts-directory ~/kkp/charts deploy \
#  --config ~/kkp/kubermatic.yaml \
#  --helm-values ~/kkp/values.yaml

# kubermatic-installer --kubeconfig ~/.kube/config \
#  --charts-directory ~/kkp/charts deploy kubermatic-seed \
#  --config ~/kkp/kubermatic.yaml \
#  --helm-values ~/kkp/values.yaml
```

## Enable Dashboard in UI

1. Open the Admin Panel of KKP UI and enable the checkbox `Enable Kubernetes Dashboard`
2. Enable the Dashboard for your cluster via `Edit Cluster` and enabling the checkbox `Kubernetes Dashboard`

## Use the Kubernetes Dashboard

1. Click on the Button `Open Dashboard` which should now exist within the Cluster and should be enabled.
