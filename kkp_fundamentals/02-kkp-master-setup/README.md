# KKP Master Setup

This chapter explains the installation procedure of KKP into a pre-existing Kubernetes cluster using installer.

>Note - To begin the installation, make sure you are using right KUBECONFIG.

Again for simplicity of training, we have the predefined manifests at [`./kkp-setup.template`](./kkp-setup.template). Copy it to `src` directory using below commands.

```bash
cp -r $TRAINING_DIR/02-kkp-master-setup/kkp-setup.template $TRAINING_DIR/src/kkp-setup
cd $TRAINING_DIR/src/kkp-setup
```

## Prepare KKP Configuration

The installation and configuration for a KKP system consists of two important files:

- A **values.yaml** used to configure the various Helm charts KKP ships with. This is where nginx, Prometheus, Dex etc. can be adjusted to the target environment. A single values.yaml is used to configure all Helm charts combined.
- A **kubermatic.yaml** that configures KKP itself and is an instance of the KubermaticConfiguration CRD. This configuration will be stored in the cluster and serves as the basis for the Kubermatic Operator to manage the actual KKP installation.

Let's start with `values.yaml`. Find out values which need to be replaced.

```bash
grep --line-number TODO values.yaml
```

```text
values.yaml:5:    host: "kubermatic.TODO-STUDENT-DNS.loodse.training"
values.yaml:12:    secret: "TODO-A-RANDOM-KEY"
values.yaml:14:    - https://kubermatic.TODO-STUDENT-DNS.loodse.training
values.yaml:15:    - https://kubermatic.TODO-STUDENT-DNS.loodse.training/projects
values.yaml:18:    - email: "TODO-STUDENT-EMAIL@loodse.training"
values.yaml:23:      username: "TODO-STUDENT-EMAIL@loodse.training"
```
  
### Replace TODO-STUDENT-DNS

We need to set the necessary domain names in the `values.yaml`. Cert-manager will use these domains to request the necessary certificates from Let's encrypt later on.

Find every entry of: TODO-STUDENT-DNS
```bash 
grep --line-number TODO-STUDENT-DNS ./*.yaml
```

Get gcloud DNS_ZONE
```bash
gcloud dns managed-zones list
```

```text
NAME                DNS_NAME                             DESCRIPTION  VISIBILITY
student-XX-xxxx     student-XX-xxxx.loodse.training.     k8c          public
```

Export your zone name
```bash
export DNS_ZONE=student-XX-xxxx   #WITHOUT loodse.training!
```
**Alternative:** You could create an empty dns zone without the External IP linked to it, like student.hosted.domain.name until when KKP has been installed on our cluster, we can now link the External IP to an AWS Route 53 record created just like the empty dns record we put in our yaml file. Example: `export DNS_ZONE=student.xxx.xxxx.x`

Replace TODO-STUDENT-DNS with your DNS.
```bash
sed -i 's/TODO-STUDENT-DNS/'"$DNS_ZONE"'/g' ./*.yaml
```

Verify - Output will be blank if everything is correct.
```bash
grep --line-number TODO-STUDENT-DNS ./*.yaml
```
Check if everything is correct and is matching your configured target DNS Zone!
```bash
grep --line-number $DNS_ZONE ./*.yaml
```

```text
./kubermatic.globalsetting.yaml:14:    url: https://kubermatic.student-00.loodse.training/rest-api
./kubermatic.yaml:24:    domain: kubermatic.student-00.loodse.training
./values.yaml:5:    host: "kubermatic.student-00.loodse.training"
./values.yaml:14:    - https://kubermatic.student-00.loodse.training
./values.yaml:15:    - https://kubermatic.student-00.loodse.training/projects
```

### Configure DEX authentication

[Dex](https://dexidp.io/) is an identity service that uses [OpenID Connect](https://openid.net/connect/) to drive authentication. To place Kubermatic behind a single-sign-on (SSO) provider, we deployed [Dex](https://dexidp.io/docs/kubernetes/).

For proper authentication, shared secrets must be configured between Dex and KKP.

Generate first a new secret:
```bash
export RANDOM_SECRET=$(base64 < /dev/urandom | tr -dc '[:alnum:]' | head -c32)
```

Replace the placeholder `TODO-A-RANDOM-SECRET` with newly generated secret value:

```bash
sed -i 's/TODO-A-RANDOM-SECRET/'"$RANDOM_SECRET"'/g' ./values.yaml
```

Also set the same newly generated secret value for client - the KKP UI - at the `kubermatic.yaml` config:
```bash
sed -i 's/TODO-KUBERMATIC-OAUTH-SECRET-FROM-VALUES.YAML/'"$RANDOM_SECRET"'/g' ./kubermatic.yaml
```

For some service communication and cookie key, we should now also replace the following `TODO-A-RANDOM-ISSUERCOOKIEKEY` and `TODO-A-RANDOM-SERVICEACCOUNTKEY` in the `kubermatic.yaml` with some random values. Again generate two random values using below command.

```bash
export ISSUERCOOKIEKEY=$(base64 < /dev/urandom | tr -dc '[:alnum:]' | head -c32)
export SERVICEACCOUNTKEY=$(base64 < /dev/urandom | tr -dc '[:alnum:]' | head -c32)
```

```bash
sed -i 's/TODO-A-RANDOM-ISSUERCOOKIEKEY/'"$ISSUERCOOKIEKEY"'/g' ./kubermatic.yaml
sed -i 's/TODO-A-RANDOM-SERVICEACCOUNTKEY/'"$SERVICEACCOUNTKEY"'/g' ./kubermatic.yaml
```

Next step is to configure a so called [DEX Connector](https://github.com/dexidp/dex#connectors) for the user authentication.

For simplicity of training, we will just configure one static user. For that you need to replace `TODO-STUDENT-EMAIL@loodse.training` with your `student-XX-xxxx@loodse.training` email in `values.yaml`.

The default password for this  training is `password`. You can replace it by running command `htpasswd -bnBC 10 "" PASSWORD_HERE | tr -d ':\n' | sed 's/$2y/$2a/'` by replacing `PASSWORD_HERE` with your desired password and replace it in `values.yaml`.

```bash
vim values.yaml
```

```yaml
  # For testing purposes, we configure a single static user/password combination.
  staticPasswords:
    - email: "TODO-STUDENT-EMAIL@loodse.training"    <<< CHANGE
      # bcrypt hash of the string "password", can be created using recent versions of htpasswd:
      # `htpasswd -bnBC 10 "" PASSWORD_HERE | tr -d ':\n' | sed 's/$2y/$2a/'`
      hash: "$2a$10$GIfuOhkTsbmdKISjFOFA6u88cr8BS0g3sZYp1kKJ3Fb/CUVryW1i2"  <<< CHANGE
      # these are used within Kubermatic to identify the user
      username: "TODO-STUDENT-EMAIL@loodse.training" <<< CHANGE
      userID: "08a8684b-db88-4b73-90a9-3cd1661f5466"
```

>NOTE: As an alternative of Dex, existing Keycloak installation could also be configured. Have a look in the [Kubermatic Docs](https://docs.kubermatic.com/kubermatic/master/tutorials_howtos/oidc_provider_configuration/) for more information.


## Configure Telemetry
Generate first a new UUID:
```bash
export RANDOM_UUID=$(uuidgen -r)
```

Replace the placeholder `TODO-RANDOM-UUID` with newly generated secret value:

```bash
sed -i 's/TODO-RANDOM-UUID/'"$RANDOM_UUID"'/g' ./values.yaml
```

### Validate all variables are set

```bash
grep --line-number TODO ./*.yaml
```
>Output should be blank.

## Download the KKP Installer

Run below command to download latest Kubermatic installer.

```bash
make download-kkp-ce-release
ls -la ./releases/
```

```text
total 12
drwxr-xr-x 3 kubermatic root 4096 Aug 19 12:55 .
drwxr-xr-x 3 kubermatic root 4096 Aug 19 12:55 ..
drwxr-xr-x 4 kubermatic root 4096 Aug 19 12:55 v2.20.2
 ```

## Install KKP

With the prepared configuration, it's now time to install the required Helm charts into the master cluster. Run below command to install KKP.

```bash
./releases/v2.20.2/kubermatic-installer --verbose --charts-directory ./releases/v2.20.2/charts deploy --config kubermatic.yaml --helm-values values.yaml --storageclass gce
```

After a few minutes, the installer should have been everything created and you will see:

```text
INFO[00:10:54]    📡 Determining DNS settings…               
DEBU[00:10:54]       Waiting for "nginx-ingress-controller/nginx-ingress-controller" to be ready… 
INFO[00:10:54]       The main LoadBalancer is ready.        
INFO[00:10:54]                                              
INFO[00:10:54]         Service             : nginx-ingress-controller / nginx-ingress-controller 
INFO[00:10:54]         Ingress via IP      : 34.141.244.62  
INFO[00:10:54]                                              
INFO[00:10:54]       Please ensure your DNS settings for "kubermatic.student-00.loodse.training" include the following records: 
INFO[00:10:54]                                              
INFO[00:10:54]          kubermatic.student-00.loodse.training.    IN  A  34.141.244.62 
INFO[00:10:54]          *.kubermatic.student-00.loodse.training.  IN  A  34.141.244.62 
INFO[00:10:54]                                              
INFO[00:10:54] 🛬 Installation completed successfully. Time for a break, maybe? ☺ 
```


### Apply the ClusterIssuer defintion

> Before applying, replace the `TODO-STUDENT-EMAIL@loodse.training` with your `student-XX-xxxx@loodse.training` email in the `clusterissuer.yaml`. 
```bash
kubectl apply -f clusterissuer.yaml
```

### Validate Ingress `nginx-ingress-controller`

Now validate if everything is running in `nginx-ingress-controller` namespace, and you have an active service.

```bash
kubectl get pod,svc,ep -n nginx-ingress-controller
```

```text
NAME                                           READY   STATUS    RESTARTS   AGE
pod/nginx-ingress-controller-75f566958-2txkg   1/1     Running   0          7m18s
pod/nginx-ingress-controller-75f566958-wr4j4   1/1     Running   0          7m18s
pod/nginx-ingress-controller-75f566958-z7s9n   1/1     Running   0          7m18s

NAME                               TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)                      AGE
service/nginx-ingress-controller   LoadBalancer   10.103.3.87   34.91.40.238   80:31542/TCP,443:31806/TCP   7m18s

NAME                                 ENDPOINTS                                               AGE
endpoints/nginx-ingress-controller   10.244.3.2:80,10.244.4.9:80,10.244.5.2:80 + 3 more...   7m18s
```

### Validate Let's Encrypt certificate manager `cert-manager`

Next validate the installation of the cert-manager to get valid SSL certificates from [Let's Encrypt](https://letsencrypt.org/) by using the Kubernetes project [Cert Manager](https://cert-manager.io/docs/):

Check if everything is running, and you have an active service:

```bash
kubectl get pod,svc,ep -n cert-manager
```

### Validate Dex OAuth proxy `oauth`

Validate that the resources have been created:

```bash
kubectl -n oauth get pod,svc,ep
```

### Validate the `Kubermatic operator`

With the `kubermatic.yaml` we triggered the deployment of the Kubermatic components by the so-called "Kubermatic Operator". Validate status of resources.

```bash
kubectl -n kubermatic get deployments,pods
```

```text
NAME                                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kubermatic-api                         0/2     2            0           19m
deployment.apps/kubermatic-dashboard                   2/2     2            2           19m
deployment.apps/kubermatic-master-controller-manager   1/1     1            1           19m
deployment.apps/kubermatic-operator                    1/1     1            1           20m

NAME                                                        READY   STATUS             RESTARTS   AGE
pod/kubermatic-api-7dccb7ff7f-77k94                         0/1     CrashLoopBackOff   8          19m
pod/kubermatic-api-7dccb7ff7f-lf244                         0/1     CrashLoopBackOff   8          19m
pod/kubermatic-dashboard-5cc96f5b67-r9bwh                   1/1     Running            0          19m
pod/kubermatic-dashboard-5cc96f5b67-t65sw                   1/1     Running            0          19m
pod/kubermatic-master-controller-manager-84cccb664f-krfdv   1/1     Running            0          19m
pod/kubermatic-operator-5b8db958b6-fxvkf                    1/1     Running            0          20m
```

As we can see `kubermatic-api` pods are in the `CrashLoopBackOff` status, something is missing, check logs:

```bash
kubectl logs -n kubermatic kubermatic-api-xxxxxxxxx-xxxxx
```

```text
{"level":"info","time":"2021-05-28T00:27:35.242Z","caller":"cli/hello.go:36","msg":"Starting Kubermatic API (Enterprise Edition)...","version":"v2.20.2"}
I0528 00:27:36.343760       1 request.go:645] Throttling request took 1.020000542s, request: GET:https://10.96.0.1:443/apis/coordination.k8s.io/v1?timeout=32s
{"level":"fatal","time":"2021-05-28T00:27:36.606Z","caller":"kubermatic-api/main.go:126","msg":"failed to create an openid authenticator","issuer":"https://kubermatic.student-00.loodse.training/dex","oidcClientID":"kubermatic","error":"Get \"https://kubermatic.student-00.loodse.training/dex/.well-known/openid-configuration\": dial tcp: lookup kubermatic.student-00.loodse.training on 169.254.20.10:53: no such host"
```

It's complaining about `dial tcp: lookup kubermatic.student-00.loodse.training on 169.254.20.10:53: no such host`. As our installer told us, now we need to set correct DNS entries after installation completes.

>NOTE: Every change in configuration file can be executed by `kubectl apply -f kubermatic.yaml`. The Operator will update the Kubermatic installation accordingly. If you delete the `KubermaticConfiguration`, e.g. with `kubectl delete -f kubermatic.yaml`, the operator will also **DELETE** all Kubermatic components!

Jump > [Home](../README.md) | Previous > [KubeOne Cluster Setup](../01-kubeone-cluster-setup/README.md) | Next > [Master DNS Setup](../03-master-dns-setup/README.md)