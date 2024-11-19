# Templating Applications

In this lab you will create some application definitions. Afterwards those applications will be deployable in the user clusters. The application manifests have to be applied against the master cluster.

## Apply the Application Defintions

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
# verify the helm releases
helm --kubeconfig ~/kubeconfig-admin-XXXXX ls -A

# verify the echoserver application
kubectl --kubeconfig=~/kubeconfig-admin-XXXXX -n echoserver get all
kubectl --kubeconfig=~/kubeconfig-admin-XXXXX -n echoserver get endpoints
kubectl --kubeconfig=~/kubeconfig-admin-XXXXX -n echoserver describe ingress echoserver-echoserver-echo-server

# verify the ingress-nginx application
kubectl --kubeconfig ~/kubeconfig-admin-XXXXX -n ingress-nginx get all

# get the external ip address of the ingress-controller
kubectl --kubeconfig ~/kubeconfig-admin-XXXXX -n ingress-nginx get svc ingress-nginx-ingress-nginx-controller

# verify the stack via curl
curl http://<EXTERNAL-IP>:80/ | jq

# verify the stack via browser
# visit the url in your browser (pay attention that you are using http) - eg http://34.89.197.223:80/
# => you will receive the response from the echo server
```
