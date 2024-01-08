# Application Configuration via ConfigMaps

In this example, we will deploy an app called `my-app` and it will read `application.properties` from a ConfigMap.

Change into the lab directory:

```bash
cd $HOME/trainings/kubernetes_application_development/01_configmaps
```

Apply the manifests:

```bash
kubectl apply -f k8s/
```

Try to reach the application:

```bash
curl http://${INGRESS_IP}/my-app

# output:
# <html>
# <head><title>502 Bad Gateway</title></head>
# <body>
# <center><h1>502 Bad Gateway</h1></center>
# <hr><center>nginx</center>
# </body>
# </html>
```

The application seems to be unreachable, try to find the reason. Possible commands to help:

```bash
kubectl describe pod my-app

kubectl describe svc my-app

kubectl get cm my-configmap -o yaml | yq '.data'
```

Fix the error, and try again.

> [!IMPORTANT]  
> ConfigMap changes will not be reflected automatically. You need to restart the pod. (In this case, recreate/replace)


## Cleanup

Remove the created objects, and go back to training home:

```bash
kubectl delete -f k8s/
cd ..
```

---

Jump > [Setup](../00_setup/README.md) | Next > [Secrets](../02_secrets/README.md)
