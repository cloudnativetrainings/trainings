# Deploy Sample Application (with external access)

The application stack with external access will be created with the following steps:

* Deploy an Ingress Controller as a reverse proxy to terminate the HTTP/HTTPS traffic and forward to the respective deployment
* CertManager will be used to create the necessary SSL certificate from Let's Encrypt 
* Deploy the hello-world application and try to access it

## Deploy [Nginx Ingress](https://github.com/kubernetes/ingress-nginx)

* First, we install the ingress controller (Nginx):
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud/deploy.yaml
  ```

* Verify the Ingress load balancer
  
  Switch the context to `ingress-nginx`
  ```bash
  kubectl config set-context --current --namespace=ingress-nginx
  ```
  or
  ```bash
  kcns ingress-nginx
  ```

  Check the LoadBalancer service type for the Nginx ingress controller:
  ```bash
  kubectl get pod,svc,ep
  ```

  ```text
  NAME                                            READY   STATUS      RESTARTS   AGE
  pod/ingress-nginx-admission-create-ddqn2        0/1     Completed   0          3m11s
  pod/ingress-nginx-admission-patch-5kg9d         0/1     Completed   0          3m11s
  pod/ingress-nginx-controller-86cbd65cf7-4s4jh   1/1     Running     0          3m21s

  NAME                                         TYPE           CLUSTER-IP       EXTERNAL-IP    PORT(S)                      AGE
  service/ingress-nginx-controller             LoadBalancer   10.109.207.66    34.90.218.24   80:30075/TCP,443:32404/TCP   3m21s
  service/ingress-nginx-controller-admission   ClusterIP      10.104.253.212   <none>         443/TCP                      3m21s

  NAME                                           ENDPOINTS                      AGE
  endpoints/ingress-nginx-controller             10.244.7.3:80,10.244.7.3:443   3m21s
  endpoints/ingress-nginx-controller-admission   10.244.7.3:8443                3m21s
  ```

## Deploy the [Cert Manager](https://cert-manager.io/docs/)

Let's deploy the CertManager:
* Install the CustomResourceDefinitions and cert-manager itself
  ```bash
  kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.yaml
  ```

* Check the pods
  ```bash
  kubectl get pods -n cert-manager
  ```
  ```text
  NAME                                       READY   STATUS    RESTARTS   AGE
  cert-manager-57f89dbdf6-448w8              1/1     Running   0          44m
  cert-manager-cainjector-6c78fb8b77-jksrl   1/1     Running   0          44m
  cert-manager-webhook-5567d8d596-k7szh      1/1     Running   0          44m
  ```

### Create the necessary DNS A records just like below

>HINT: some of the IP's can only be determined after the ingress controller's service is deployed

* First, start a DNS zone editing transaction.
  Ensure gcloud use the correct project
  ```bash
  gcloud projects list
  gcloud config set project student-XX-xxxx
  ```
  Set DNS_ZONE
  ```bash
  gcloud dns managed-zones list
  ```
  ```text
  NAME                DNS_NAME                             DESCRIPTION                VISIBILITY
  student-XX-XXXX     student-XX-XXXX.loodse.training.     zone for student-XX-XXXX  public
  ```
  Adjust to your zone name
  ```bash
  export DNS_ZONE=student-XX-XXXX
  gcloud dns record-sets transaction start --zone=$DNS_ZONE
  ```

* Then proceed to add the A records:
  `*.student-XX-XXXX.loodse.training`  ---->  LoadBalancer IP address of the Nginx Service
  ```bash
  kubectl get svc -n ingress-nginx
  ```
  Use your external service ip
  ```bash
  export SERVICE_NGINX_EXT_IP=xx.xx.xx.xx
  gcloud dns record-sets transaction add --zone=$DNS_ZONE --name="*.$DNS_ZONE.loodse.training" --ttl 300 --type A $SERVICE_NGINX_EXT_IP
  ```

* Finally, verify DNS transaction yaml and execute those changes.
  ```bash
  cat transaction.yaml
  gcloud dns record-sets transaction execute --zone $DNS_ZONE
  ```
  >*Hint*: On Errors you can also modify the created `transaction.yaml` or fix the error over google console [Cloud DNS](https://console.cloud.google.com/net-services/dns/zones).

* Confirm the DNS records:
  ```bash
  gcloud dns record-sets list --zone=$DNS_ZONE
  ```

  ```text
  NAME                                           TYPE   TTL    DATA
  *.student-XX.loodse.XXXX.                      A      300    34.90.218.24
  ```

**Alternative:** You could create an AWS Route 53 record on a hosted domain and link the `$EXTERNAL IP` accordingly to create DNS for `student-XX-XXXX.domain.name` and `*.student-XX-XXXX.domain.name`

### Create a Cluster Issuer

* Apply the cluster issuer yaml 
  >ATTENTION: View and edit the .yaml files before you apply !!!

  >Use email provided by trainer for `TRAINING_EMAIL`
  ```bash
  cd $TRAINING_DIR/07_deploy-app-02-external-access
  export TRAINING_EMAIL=student-XX.XXXX@loodse.training       
  sed -i "s/your-email@example.com/$TRAINING_EMAIL/g" manifests/lb.cluster-issuer.yaml
  kubectl apply -f manifests/lb.cluster-issuer.yaml
  ```
* Check the status
  ```bash
  kubectl describe clusterissuers.cert-manager.io letsencrypt-issuer
  ```

***N.B - Since http01 is used to issue the certificate, ensure that you create a DNS A record for the domain, this A record should point to the IP address of the Nginx Ingress controller load balancer service.***

*Wait for the DNS to propagate, then proceed to install the SSL certificates from Let's encrypt:*

### Deploy the sample application

Let's deploy a sample application. This will entail creating a deployment, a service, an ingress and a certificate.

* Create a new app-ext namespace
  ```bash
  kubectl create ns app-ext
  kubectl config set-context --current --namespace=app-ext
  ```
  or
  ```bash
  kcns app-ext
  ```

* Apply the deployment manifest
  ```bash
  kubectl apply -f manifests/app.deployment.yaml
  ```

* Apply the service manifest
  ```bash
  kubectl apply -f manifests/app.service.yaml
  ```

Now let's configure a valid SSL certificate for you app. `sed` will replace `TODO-YOUR-DNS-ZONE` with your DNS ZONE, e.g.:`student-XX-XXXX.loodse.training`. Please ensure you will use **YOUR STUDENT ID**:

* Check no certificate is present
  ```bash
  kubectl get certificates
  ```

* Ingress manifest: Update the DNS_ZONE to your dedicated student DNS zone
  ```bash
  sed -i 's/TODO-YOUR-DNS-ZONE/'"$DNS_ZONE"'/g' manifests/app.ingress.yaml
  kubectl apply -f manifests/app.ingress.yaml
  ```

* Check the status of the SSL certificate (ensure that the status is True and Ready):
  ```bash
  kubectl get certificates -o yaml
  ```

**Check the status of the application components**

```bash
kubectl get pods
```

```text
NAME                        READY   STATUS    RESTARTS   AGE
helloweb-7f7f7474fc-rgwl6   1/1     Running   0          11s
```

```bash
kubectl describe svc helloweb
```

```text
Name:              helloweb
Namespace:         default
Labels:            app=hello
Selector:          app=hello,tier=web
Type:              ClusterIP
IP:                10.102.189.51
Port:              <unset>  80/TCP
TargetPort:        8080/TCP
Endpoints:         10.244.3.8:8080
Session Affinity:  None
Events:            <none>
```

```bash
kubectl get ingresses.networking.k8s.io
```

```text
NAME       HOSTS                                     ADDRESS          PORTS      AGE
helloweb   app-ext.student-XX-XXXX.loodse.training   34.90.218.24     80, 443    98s
```

Ensure that there are endpoints available for the service.

Test the application (this is being served via the ingress controller with the Let's encrypt SSL certificate):

```bash
echo https://app-ext.$DNS_ZONE.loodse.training
```
Your DNS zone should be displayed. Similar to https://app-ext.YOUR-DNS-ZONE.loodse.training
```bash
curl https://app-ext.$DNS_ZONE.loodse.training
```

```text
Hello, world!
Version: 1.0.0
Hostname: helloweb-7f7f7474fc-rgwl6
```

**Some ingress logs to show that the traffic is passing through it:**

```bash
kubectl logs -n ingress-nginx ingress-nginx-controller-XXXXX-xxxx
```
or use the fuzzy way to follow the logs
```bash
klog -f
# type ingress, select the ingress controller pod
```

```text
I0717 11:06:04.032365       6 status.go:296] updating Ingress default/helloweb status from [] to [{34.90.218.24 }]
I0717 11:06:04.039261       6 event.go:258] Event(v1.ObjectReference{Kind:"Ingress", Namespace:"default", Name:"helloweb", UID:"c3748923-a882-11e9-aac8-42010af00003", APIVersion:"networking.k8s.io/v1beta1", ResourceVersion:"18930", FieldPath:""}): type: 'Normal' reason: 'UPDATE' Ingress default/helloweb


I0717 11:06:36.110931       6 event.go:258] Event(v1.ObjectReference{Kind:"Ingress", Namespace:"default", Name:"helloweb", UID:"c3748923-a882-11e9-aac8-42010af00003", APIVersion:"networking.k8s.io/v1beta1", ResourceVersion:"19038", FieldPath:""}): type: 'Normal' reason: 'UPDATE' Ingress default/helloweb

I0717 11:06:36.110991       6 backend_ssl.go:58] Updating Secret "default/loodse-dev-tls" in the local store

I0717 11:06:36.111294       6 controller.go:133] Configuration changes detected, backend reload required.

I0717 11:06:36.212252       6 controller.go:149] Backend successfully reloaded.
[17/Jul/2019:11:06:36 +0000]TCP200000.000

10.240.0.5 - [10.240.0.5] - - [17/Jul/2019:11:07:12 +0000] "GET / HTTP/2.0" 200 65 "-" "curl/7.64.0" 39 0.001 [default-helloweb-80] [] 10.244.3.8:8080 65 0.000 200 336f1ccd6efbde55fc2505fee6dc7ab5
```

You can keep the application deployed for now as we will use that in upcoming step.


Jump > [**Home**](../README.md) | Previous > [**HA Worker Pool**](../06_HA-worker/README.md) | Next > [**Optimization of Workers**](../08_optimize-workers/README.md)