# Initial Setup

## Dependencies

Kubermatic ships with a number of Helm charts that need to be installed into the master or seed clusters. These are built so they can be configured using a single, shared `values.yaml` file. The required charts are:

* **Master cluster:** cert-manager, nginx-ingress-controller, oauth(, iap)
* **Seed cluster:** minio, s3-exporter

There are additional charts for the [monitoring](https://github.com/kubermatic/kubermatic/tree/master/charts/monitoring) and [logging stack](https://github.com/kubermatic/kubermatic/tree/master/charts/logging) which will be discussed in their dedicated chapters, as they are not strictly required for running Kubermatic.

In addition to the `values.yaml` for configuring the charts, a number of options will later be made inside a special
`KubermaticConfiguration` resource.

A minimal configuration for Helm charts sets the options. A template what you will fill out step-by-step is placed at [kkp-setup.template/values.yaml](kkp-setup.template/values.yaml). To configure your own version, please create first a copy to your `kkp-setup` folder:
```bash
cd [training-repo]
cp -r 02-intial_setup/kkp-setup.template src/kkp-setup
```

For the purpose of this chapter, we only need to configure a few things in the `values.yaml`, check:
```bash
cd src/kkp-setup
grep --line-number TODO values.yaml
values.yaml:10:#          "auth": "TODO ADD PULL SECRET",
values.yaml:20:    host: "kubermatic.TODO-STUDENT-DNS.loodse.training"
values.yaml:30:    - https://kubermatic.TODO-STUDENT-DNS.loodse.training
values.yaml:32:    - https://kubermatic.TODO-STUDENT-DNS.loodse.training/projects
values.yaml:35:    - email: "TODO-STUDENT-EMAIL@loodse.training"
```

### Configure an image pull secret for Kubermatic images
**NOTE:** If you don't have the EE key present as your trainer - or check how to [config CE Version](https://docs.kubermatic.com/kubermatic/master/guides/installation/install_kkp_ce/) ;-)

To enable the Kubermatic master cluster to download the protected Kubermatic images, we need to configure a secret in the `values.yaml`. This will be used later for the deployment of the Helm files.
```bash
cat secrets/kubermatic-*.json
```
```json
{
  "auths": {
    "quay.io": {
      "auth": "xxx-YOUR-SECRET-KEY-xxx",
      "email": ""
    }
  }
}
```
Now replace the path `TODO-ADD-PULL-SECRET` in the `values.yaml` and `kubermatic.yaml`:
```bash
vim values.yaml
```
and then replace
```yaml
  # insert the Docker authentication JSON provided by Kubermatic here
  imagePullSecret: |
    {
      "auths": {
        "quay.io": {
          "auth": "xxx-YOUR-SECRET-KEY-xxx",
          "email": ""
        }
      }
    }
```

## Configure DEX authentication
To start simple we already added a basic configuration for a static OAuth ID.

Generate first a new secret how the later KKP UI can communicate to the DEX Authentication service:
```bash
cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32
```
```bash
vim values.yaml
```
```yaml

  clients:
  # The "kubermatic" client is used for logging into the Kubermatic dashboard. It always needs to be configured.
  - id: kubermatic
    name: Kubermatic
    # generate a secure secret key with:
    # cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32
    secret: "TODO-A-RANDOM-KEY"   <<<< CHANGE
    RedirectURIs:
```
Also set the **SAME** secret for client - the KKP UI - at the `kubermatic.yaml` config:
```
vim kubermatic.yaml
```
```yaml

    # this must match the secret configured for the kubermatic client from
    # the values.yaml.
    issuerClientSecret: TODO-KUBERMATIC-OAUTH-SECRET-FROM-VALUES.YAML  <<< CHANGE 
```
For some service communication and ann cookie key, we should now also replace the following TODOs in the `kubermatic.yaml` with some OTHER random values:
```bash
cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32
cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32
```
```yaml
    # these need to be randomly generated. Those can be generated on the
    # shell using:
    # cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32
    issuerCookieKey: TODO-A-RANDOM-KEY
    serviceAccountKey: TODO-A-RANDOM-KEY
```
Now as KKP and [DEX](https://github.com/dexidp/dex) can talk to each other, we need to configure a so called [DEX Connector](https://github.com/dexidp/dex#connectors) for the user authentication at the DEX authentication proxy. For now, we will just configure one static user. For this you need to replace `TODO-STUDENT-EMAIL@loodse.training` with your `student-XX-xxx@loodse.training` email. The default password is `password`

```yaml
  # For testing purposes, we configure a single static user/password combination.
  staticPasswords:
    - email: "TODO-STUDENT-EMAIL@loodse.training" <<<< CHANGE
      # bcrypt hash of the string "password", can be created using recent versions of htpasswd:
      # `htpasswd -bnBC 10 "" PASSWORD_HERE | tr -d ':\n' | sed 's/$2y/$2a/'`
      hash: "$2a$10$2b2cU8CPhOTaGrs1HRQuAueS7JTT5ZHsHSzYiFPm1leZck7Mc8T4W"
      # these are used within Kubermatic to identify the user
      username: "TODO-STUDENT-EMAIL@loodse.training"
      userID: "08a8684b-db88-4b73-90a9-3cd1661f5466"
```
**NOTE:** This is **not recommended for production!**
In a later chapter we  will change the ID to a proper OIDC Authentication configuration.

## Configure target DNS

As a next step we need to set the target DNS name.

* Base URL will be: **kubermatic.*STUDENT_DNS_NAME*.loodse.training** 

  For this demonstration we will be using **kubermatic.student-00.loodse.training**

  This domain name will point to the Load balancer IP address of the Nginx ingress controller service.

  For the system services like Prometheus or Grafana, you will also want to create a wildcard DNS A record `*.kubermatic.student-00.loodse.training` pointing to the same Load Balancer IP of the Nginx ingress controller.
  
### Replace TODO-STUDENT-DNS
Next we want to configure the DNS names in the `values.yaml`. Before we create the DNS entries with the according LoadBalancer IP, we need to set the necessary domain names in the values.yaml. Cert-manager will use these domains to request the necessary certificates from Let's encrypt later on:

```bash
## replace every entry of: TODO-STUDENT-DNS
grep --line-number TODO-STUDENT-DNS ./*.yaml

# get gcloud DNS_ZONE
gcloud dns managed-zones list
NAME                DNS_NAME                             DESCRIPTION  VISIBILITY
student-XX-training student-XX-training.loodse.training. k8c          public

## adjust to your zone name
export DNS_ZONE=student-XX-training
# sed -i 's/original/new/g' file
sed -i 's/TODO-STUDENT-DNS/'"$DNS_ZONE"'/g' ./*.yaml

## check results
grep --line-number TODO-STUDENT-DNS ./*.yaml
grep --line-number $DNS_ZONE ./*.yaml
```
**Check if everything is correct and is matching your configured target DNS Zone!**
```
./kubermatic.globalsetting.yaml:14:    url: https://kubermatic.student-00.loodse.training/rest-api
./kubermatic.yaml:33:    domain: kubermatic.student-00.loodse.training
./values.yaml:18:    host: "kubermatic.student-00.loodse.training"
./values.yaml:27:    - https://kubermatic.student-00.loodse.training
./values.yaml:28:    - https://kubermatic.student-00.loodse.training/projects
```

## Download the latest EE Version

Check the Makefile target download-kkp-release binaries and charts:
```
cat Makefile
#...
download-kkp-release:
	mkdir -p ${KKP_RELEASE_ROOT_FOLDER}/${KKP_VERSION}
	wget https://github.com/kubermatic/kubermatic/releases/download/${KKP_VERSION}/kubermatic-ee-${KKP_VERSION}-linux-amd64.tar.gz -O- | tar -xz --directory ${KKP_RELEASE_ROOT_FOLDER}/${KKP_VERSION}/
```
Download it:
```
make download-kkp-release
```

## Install Basic Setup and Dependencies

With the configuration prepared, it's now time to install the required Helm charts into the master cluster. Take note of where you placed your `values.yaml` and then run the following commands in your shell:
```
ls -la ./releases/
total 12
drwxr-xr-x 3 kubermatic root 4096 May 27 22:52 .
drwxr-xr-x 3 kubermatic root 4096 May 27 22:52 ..
drwxr-xr-x 4 kubermatic root 4096 May 27 22:52 v2.17.0

#... use latest version
./releases/v2.17.0/kubermatic-installer --verbose --charts-directory ./releases/v2.17.0/charts deploy --config kubermatic.yaml --helm-values values.yaml
```

You will get receive the following error:
```
WARN[23:27:46]       The kubermatic-fast StorageClass does not exist yet. Depending on your environment, 
WARN[23:27:46]       the installer can auto-create a class for you, see the --storageclass CLI flag. 
WARN[23:27:46]       Alternatively, please manually create a StorageClass and then re-run the installer to continue. 
ERRO[23:27:46] ❌ Operation failed: failed to deploy StorageClass: no kubermatic-fast StorageClass found.
```
As we didn't creat a correct storage class

## Kubermatic storage class `kubermatic-fast`

The storage class `kubermatic-fast` is needed so as to cater for the creation of persistent volume claims (PVCs) for some of the components of Kubermatic. The following components need a persistent storage class assigned:

* User cluster ETCD statefulset
* Prometheus and Alertmanager (monitoring)
* Elasticsearch (logging)

**It’s highly recommended to use SSD-based volumes, as etcd is very sensitive to slow disk I/O. If your cluster already provides a default SSD-based storage class, you can simply copy and re-create it as `kubermatic-fast.`**

### Create storage class GCE
Since `v2.17.0` you could also set the flag `kubermatic-installer --storageclass gce` as a shortcut, but we should expect that we may want to change some parameters, so  let's create a `kubermatic-fast` storage class, see [`./kkp-setup.template/gce.sc.kubermatic.fast.yaml`](./kkp-setup.template/gce.sc.kubermatic.fast.yaml) template file what have been already copied.

After everything looks fine, apply the new storage class:
```bash 
kubectl apply -f gce.sc.kubermatic.fast.yaml
```
Check that you now have a new storage class installed:
```bash
kubectl get sc
```
```
NAME                        PROVISIONER            AGE
kubermatic-fast             kubernetes.io/gce-pd   12s
```
For more details about the storage class parameters of the Google CCM, see [Kubernetes Storage Class - GCE PD](https://kubernetes.io/docs/concepts/storage/storage-classes/#gce-pd).

Now redo our command:
```
./releases/v2.17.0/kubermatic-installer --verbose --charts-directory ./releases/v2.17.0/charts deploy --config kubermatic.yaml --helm-values values.yaml
```

### Ingress `nginx-ingress-controller`
After a few moments the installer should have been everything created, and you will see:
```
INFO[00:10:54]    📡 Determining DNS settings…               
DEBU[00:10:54]       Waiting for "nginx-ingress-controller/nginx-ingress-controller" to be ready… 
INFO[00:10:54]       The main LoadBalancer is ready.        
INFO[00:10:54]                                              
INFO[00:10:54]         Service             : nginx-ingress-controller / nginx-ingress-controller 
INFO[00:10:54]         Ingress via IP      : 34.141.244.62  
INFO[00:10:54]                                              
INFO[00:10:54]       Please ensure your DNS settings for "kubermatic.test-01-int-05.loodse.training" include the following records: 
INFO[00:10:54]                                              
INFO[00:10:54]          kubermatic.test-01-int-05.loodse.training.    IN  A  34.141.244.62 
INFO[00:10:54]          *.kubermatic.test-01-int-05.loodse.training.  IN  A  34.141.244.62 
INFO[00:10:54]                                              
INFO[00:10:54] 🛬 Installation completed successfully. Time for a break, maybe? ☺ 
```

Now check if everything is running, and you have an active service:
```bash
kubectl get pod,svc,ep -n nginx-ingress-controller 
```
```
NAME                                           READY   STATUS    RESTARTS   AGE
pod/nginx-ingress-controller-75f566958-2txkg   1/1     Running   0          7m18s
pod/nginx-ingress-controller-75f566958-wr4j4   1/1     Running   0          7m18s
pod/nginx-ingress-controller-75f566958-z7s9n   1/1     Running   0          7m18s

NAME                               TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)                      AGE
service/nginx-ingress-controller   LoadBalancer   10.103.3.87   34.91.40.238   80:31542/TCP,443:31806/TCP   7m18s

NAME                                 ENDPOINTS                                               AGE
endpoints/nginx-ingress-controller   10.244.3.2:80,10.244.4.9:80,10.244.5.2:80 + 3 more...   7m18s
```
**NOTE:** Not all cloud providers provide support for LoadBalancers. In these environments the `nginx-ingress-controller` chart can be configured to use a NodePort Service instead, which would open ports 80 and 443 on every node of the cluster. Refer to the `charts/nginx-ingress-controller/values.yaml` for more information.

### Let's Encrypt certificate manager `cert-manager`
Next check the installation of the cert-manager to get valid SSL certificates from [Let's Encrypt](https://letsencrypt.org/) by using the Kubernetes project [Cert Manager](https://cert-manager.io/docs/):

Now check if everything is running and you have an active service:
```bash
kubectl get pod,svc,ep -n cert-manager
```
Also let's see if a cluster issuer have been created:  
```bash
kubectl get clusterissuers.cert-manager.io 
```
```
NAME                  READY   AGE
letsencrypt-prod      True    58m
letsencrypt-staging   True    58m
```

### Dex OAuth proxy `oauth`

To place Kubermatic behind a single-sign-on (SSO) provider, we deployed [Dex](https://github.com/dexidp/dex/blob/master/Documentation/kubernetes.md) 

**NOTE:** As an alternative an existing Keycloak installation could also be configured. Have a look in the [Kubermatic Docs](https://docs.kubermatic.com/kubermatic/master/advanced/oidc_config/) for more information.

Validate that the resources have been created:
```bash
kubectl -n oauth get pod,svc,ep
```
```
NAME                            READY   STATUS    RESTARTS   AGE
pod/cm-acme-http-solver-wnc6n   1/1     Running   0          43m
pod/dex-55596f57bd-fbhrh        1/1     Running   0          43m
pod/dex-55596f57bd-sxlj8        1/1     Running   0          43m

NAME                                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/cm-acme-http-solver-dgn4z   NodePort    10.109.192.167   <none>        8089:31448/TCP   43m
service/dex                         ClusterIP   10.96.214.126    <none>        5556/TCP         43m

NAME                                  ENDPOINTS                         AGE
endpoints/cm-acme-http-solver-dgn4z   10.244.4.16:8089                  43m
endpoints/dex                         10.244.3.7:5556,10.244.5.7:5556   43m
```
**NOTE:** the missing ingress `ADDRESS` is ok for now, because we didn't setup or DNS entry yet! 

```bash
kubectl -n oauth get ingresses
```
```
NAME                        HOSTS                                   ADDRESS   PORTS     AGE
dex                         kubermatic.student-00.loodse.training             80, 443   52s
```
