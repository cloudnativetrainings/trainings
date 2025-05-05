# Deploy Sample Application (with external access)

The application stack with external access will be created with the following steps:

* Deploy an Ingress Controller as a reverse proxy to terminate the HTTP/HTTPS traffic and forward to the respective deployment
* CertManager will be used to create the necessary SSL certificate from Let's Encrypt 
* Deploy the hello-world application and try to access it

## Deploy [Nginx Ingress](https://github.com/kubernetes/ingress-nginx) and [Cert Manager](https://cert-manager.io/docs/) via Helm Integration

Helm integration is a way to automatically deploy a bunch of helm releases together with `kubeone apply`. No helm binary is required. 

* First, add below code block to the `kubeone.yaml`:

```yaml
apiVersion: kubeone.k8c.io/v1beta2
kind: KubeOneCluster
name: k1
versions:
  kubernetes: "1.31.8"
cloudProvider:
  gce: {}
  cloudConfig: |-
    [global]
    regional = true

# Add below part
helmReleases:
  - releaseName: ingress-nginx
    chart: ingress-nginx
    repoURL: https://kubernetes.github.io/ingress-nginx
    namespace: ingress-nginx
    version: 4.12.2
    values:
      - inline:
          controller:
            replicaCount: 2
            autoscaling:
              enabled: true
              minReplicas: 2
              maxReplicas: 5
              targetCPUUtilizationPercentage: 80
              targetMemoryUtilizationPercentage: 80
  - releaseName: cert-manager
    chart: cert-manager
    repoURL: https://charts.jetstack.io
    namespace: cert-manager
    version: v1.17.2
    values:
      - inline:
          crds:
            enabled: true
```

* Run `kubeone apply` to deploy:
```bash
kubeone apply -t $TRAINING_DIR/src/gce/tf-infra -m $TRAINING_DIR/src/gce/kubeone.yaml --verbose
```

* Check helm status:
```bash
helm ls -A
```

```text
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
cert-manager    cert-manager    1               2025-05-05 10:27:19.412427669 +0000 UTC deployed        cert-manager-v1.17.2    v1.17.2
ingress-nginx   ingress-nginx   1               2025-05-05 10:17:34.442043274 +0000 UTC deployed        ingress-nginx-4.12.2    1.12.2
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
  NAME                                            READY   STATUS    RESTARTS   AGE
  pod/ingress-nginx-controller-86578cc48d-cslwb   1/1     Running   0          2m13s
  pod/ingress-nginx-controller-86578cc48d-fd46w   1/1     Running   0          2m13s
  pod/ingress-nginx-controller-86578cc48d-glwwd   1/1     Running   0          2m28s

  NAME                                         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
  service/ingress-nginx-controller             LoadBalancer   10.99.143.194   34.13.244.165   80:31656/TCP,443:32209/TCP   2m28s
  service/ingress-nginx-controller-admission   ClusterIP      10.110.133.99   <none>          443/TCP                      2m28s

  NAME                                           ENDPOINTS                                                  AGE
  endpoints/ingress-nginx-controller             10.244.4.5:443,10.244.5.3:443,10.244.6.3:443 + 3 more...   2m28s
  endpoints/ingress-nginx-controller-admission   10.244.4.5:8443,10.244.5.3:8443,10.244.6.3:8443            2m28s
  ```

* Check cert-manager pods
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
  gcloud config set project $GCP_PROJECT_ID
  ```
  Set DNS_ZONE
  ```bash
  gcloud dns managed-zones list
  ```
  ```text
  NAME                DNS_NAME                                DESCRIPTION                 VISIBILITY
  student-XX-XXXX     student-XX-XXXX.cloud-native.training.  zone for student-XX-XXXX    public
  ```
  Adjust to your zone name
  ```bash
  export DNS_ZONE=$GCP_PROJECT_ID
  echo "export DNS_ZONE=$DNS_ZONE" >> $TRAINING_DIR/.trainingrc
  gcloud dns record-sets transaction start --zone=$DNS_ZONE
  ```

* Then proceed to add the A records:
  `*.student-XX-XXXX.cloud-native.training`  ---->  LoadBalancer IP address of the Nginx Service
  ```bash
  kubectl get svc -n ingress-nginx
  ```
  Use your external service ip
  ```bash
  export SERVICE_NGINX_EXT_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[].ip}')
  gcloud dns record-sets transaction add --zone=$DNS_ZONE --name="*.$DNS_ZONE.cloud-native.training" --ttl 300 --type A $SERVICE_NGINX_EXT_IP
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
  *.student-XX.kubermatic.XXXX.                  A      300    34.90.218.24
  ```

**Alternative:** You could create an AWS Route 53 record on a hosted domain and link the `$EXTERNAL IP` accordingly to create DNS for `student-XX-XXXX.domain.name` and `*.student-XX-XXXX.domain.name`

### Create a Cluster Issuer

* Apply the cluster issuer yaml 
  >ATTENTION: View and edit the .yaml files before you apply !!!

  >Use email provided by trainer for `TRAINING_EMAIL`
  ```bash
  cd $TRAINING_DIR/07_deploy-app-02-external-access
  export TRAINING_EMAIL=student-XX.XXXX@cloud-native.training       
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

Now let's configure a valid SSL certificate for you app. `sed` will replace `TODO-YOUR-DNS-ZONE` with your DNS ZONE, e.g.:`student-XX-XXXX.cloud-native.training`. Please ensure you will use **YOUR STUDENT ID**:

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
NAME       CLASS   HOSTS                                           ADDRESS       PORTS     AGE
helloweb   nginx   app-ext.student-XX-XXXX.cloud-native.training   35.204.66.3   80, 443   108s
```

Ensure that there are endpoints available for the service.

Test the application (this is being served via the ingress controller with the Let's encrypt SSL certificate):

```bash
echo https://app-ext.$DNS_ZONE.cloud-native.training
```
Your DNS zone should be displayed. Similar to https://app-ext.YOUR-DNS-ZONE.cloud-native.training
```bash
curl https://app-ext.$DNS_ZONE.cloud-native.training
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

I0717 11:06:36.110991       6 backend_ssl.go:58] Updating Secret "default/kubermatic-dev-tls" in the local store

I0717 11:06:36.111294       6 controller.go:133] Configuration changes detected, backend reload required.

I0717 11:06:36.212252       6 controller.go:149] Backend successfully reloaded.
[17/Jul/2019:11:06:36 +0000]TCP200000.000

10.240.0.5 - [10.240.0.5] - - [17/Jul/2019:11:07:12 +0000] "GET / HTTP/2.0" 200 65 "-" "curl/7.64.0" 39 0.001 [default-helloweb-80] [] 10.244.3.8:8080 65 0.000 200 336f1ccd6efbde55fc2505fee6dc7ab5
```

You can keep the application deployed for now as we will use that in upcoming step.


Jump > [**Home**](../README.md) | Previous > [**HA Worker Pool**](../06_HA-worker/README.md) | Next > [**Optimization of Workers**](../08_optimize-workers/README.md)