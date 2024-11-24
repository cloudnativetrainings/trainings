# Enable the Kubernetes Dashboard

<!-- kubermatic.yaml -->
```yaml
apiVersion: kubermatic.k8c.io/v1
kind: KubermaticConfiguration
metadata:
  name: kubermatic
  namespace: kubermatic
spec:
  featureGates:
    OIDCKubeCfgEndpoint: true
    OpenIDAuthPlugin: true
```

<!-- 
enable Dashboard in admin panel
enable Dashboard in cluster
log in via oauth2
 -->

 https://docs.kubermatic.com/kubermatic/v2.26/tutorials-howtos/oidc-provider-configuration/share-clusters-via-delegated-oidc-authentication/


change in kubermatic.yaml
change in values.yaml

kubermatic-installer --kubeconfig ~/.kube/config \
    --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml

helm --namespace oauth upgrade --install --wait --values ~/kkp/values.yam
l oauth ~/kkp/charts/oauth/

helm --namespace oauth upgrade --install --wait --values values.yaml oauth charts/oauth/

kubectl apply -f ~/kkp/kubermatic.yaml
