# Application Configuration via ConfigMaps

In this example, we will deploy an app called `my-app` and it will read the application configuration from a ConfigMap.

Change into the lab directory:

```bash
cd $HOME/trainings/kubernetes_fundamentals_for_developers/01_configmaps
```

## Configure the Application via ConfigMap

Apply the manifests:

```bash
kubectl apply -f k8s/
```

## Check the output of the application

```bash
curl http://${INGRESS_IP}/my-app

# output:
# <!DOCTYPE html><htlml><body>Message: Message from ConfigMap<br>Pod Name: <br>Pod IP: <br>Live: true<br>Ready: true<br></body></htlml>
```

> Note: You can also get the output via your browser.

> Note that the the message is taken from the ConfigMap and not from the containers default configuration file for the application.

## Changing the ConfigMap

Change the message of the ConfigMap `k8s/configmap.yaml`

```yaml
data: 
  app.conf: |-
    message = Some different message
```

Apply the change in the ConfigMap.

```bash
kubectl apply -f k8s/configmap.yaml
```

> Note: ConfigMap changes will not be reflected automatically. You need to restart the pod. (In this case, recreate/replace). You can get into tricky situations eg on deploying stuff via Helm Charts.

```bash
# restart the pod
kubectl replace -f k8s/pod.yaml --force

# verify that the message is updated
curl http://${INGRESS_IP}/my-app
```

## Additional Information

There are some automated ways to restart your applications after ConfigMap/Secret changes. For example:

1. Kyverno Policy: [Restart Deployment on a Secret Change](https://kyverno.io/policies/other/restart-deployment-on-secret-change/restart-deployment-on-secret-change/)
2. Helm: [Automatically Roll Deployments](https://helm.sh/docs/howto/charts_tips_and_tricks/#automatically-roll-deployments)

## Cleanup

```bash
kubectl delete -f k8s/
```
