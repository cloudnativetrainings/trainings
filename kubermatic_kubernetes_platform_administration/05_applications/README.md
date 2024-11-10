# Adding Application Templates

In this lab you will create some application definitions. Afterwards those applications will be deployable in the user clusters. The application manifests have to be applied against the master cluster.

```bash
cd ~/05_applications
```

<!-- # TODO get rid of the addons repo -->

## Applying the applications

```bash
# apply the application definitions
kubectl apply -f ~/kkp/applications/echoserver.yaml
kubectl apply -f ~/kkp/applications/ingress-nginx.yaml

# verify the application definitions
kubectl get applicationdefinitions
```

## Deploy the applications into your user cluster

You will be able to deploy the applications in your user cluster after ~ 30 seconds. You have to do the following in the KKP UI:

- Choose your user cluster
- Click the `Applications` Tab
- Click the `Add Application` Button
- Add the application `ingress-nginx` and the application `echoserver`

## Verify your applications got deployed into your user cluster properly

```bash
# verify the namespaces got created
kubectl --kubeconfig=~/kubeconfig-admin-XXXXX get ns

# verify the echoserver application
kubectl --kubeconfig=~/kubeconfig-admin-XXXXX -n echoserver get all
kubectl --kubeconfig=~/kubeconfig-admin-XXXXX -n echoserver get endpoints
kubectl --kubeconfig=~/kubeconfig-admin-XXXXX -n echoserver desribe echoserver-echoserver-echo-server

# verify the ingress-nginx application
kubectl --kubeconfig ~/kubeconfig-admin-njl5lrd2fz -n ingress-nginx get all

# verify the stack via browser
# copy the external-ip from the service `ingress-nginx-ingress-nginx-controller`
# visit the url in your browser (pay attention that you are using http) - eg http://34.89.197.223:80/
# => you will receive the response from the echo server
```
