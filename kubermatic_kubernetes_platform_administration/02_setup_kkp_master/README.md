# Setup KKP Master

In this lab you will create KKP Master Cluster.

```bash
cd ~/02_setup_kkp_master
```

## Install KKP

```bash
make install_kkp

# Verify installation
kubermatic-installer --version
```

## Get KKP Configuration Files

```bash
make setup_kkp_folder
```

## Configure KKP

### Exchange URLs

```bash
sed -i 's/kkp.example.com/'$GCP_DOMAIN'/g' ~/kkp/kubermatic.yaml
sed -i 's/kkp.example.com/'$GCP_DOMAIN'/g' ~/kkp/values.yaml
```

### Generate Secrets

Create random secrets via

```bash
cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32
```

for the following fields in the file `values.yaml`

- `dex.clients[kubermatic].secret`
- `dex.clients[kubermaticIssuer].secret`

and for the following fields in the file `kubermatic.yaml`

- `auth.issuerCookieKey`
- `auth.serviceAccountKey`

Copy the secret from `dex.clients[kubermaticIssuer].secret` from the file `values.yaml` into `auth.issuerClientSecret` field of the file `kubermatic.yaml`.

### Create static login credentials

```bash
sed -i 's/kubermatic@example.com/'$GCP_MAIL'/g' ~/kkp/values.yaml

# hash your password like this
htpasswd -bnBC 10 "" PASSWORD_HERE | tr -d ':\n' | sed 's/$2y/$2a/'

# set the password in the file `values.yaml` in the field `dex.staticPasswords[YOUR-EMAIL].hash`
```

### Generate uuid for telemetry

```bash
sed -i 's/uuid: \"\"/uuid: \"'$(uuidgen -r)'\"/g' ~/kkp/values.yaml
```

### Adapt Minio Settings

Change the minio settings in the file `values.yaml` to the following:

```yaml
# Take care about the proper indent in the yaml file!!!
minio:
  storeSize: "10Gi"
  storageClass: kubermatic-backup
  credentials:
    accessKey: "reoshe9Eiwei2ku5foB6owiva2Sheeth"
    secretKey: "rooNgohsh4ohJo7aefoofeiTae4poht0cohxua5eithiexu7quieng5ailoosha8"
```

## Apply StorageClasses

```bash
kubectl apply -f ~/kkp/storageclass-fast.yaml
kubectl apply -f ~/kkp/storageclass-backup.yaml
```

Verify the storage class

```bash
kubectl get sc
```

## Install KKP into K1 Cluster

```bash
kubermatic-installer --kubeconfig ~/.kube/config \
    --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml

# Verify everyting is running smoothly
# (Note that the pods kubermatic-api-XXXXX will not run smoothly due to DNS is not setup yet)
watch -n 1 kubectl -n kubermatic get pods
```

## Setup DNS and TLS

### Apply the Production Cert-Manager ClusterIssuer

For having TLS communication we are using cert-manager.

```bash
# Change the email address
sed -i 's/TODO-STUDENT-EMAIL@cloud-native.training/'$GCP_MAIL'/g' ~/kkp/clusterissuer.yaml

kubectl apply -f ~/kkp/clusterissuer.yaml
```

### Configure DNS

Configure the DNS records for accessing KKP UI.

```bash
# Store IP of Loadbalancer into environment variable
export INGRESS_IP=$(kubectl -n nginx-ingress-controller get service nginx-ingress-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Verify that environment variable is set
echo $INGRESS_IP

make IP=$INGRESS_IP create_dns_records

# Verify DNS records
nslookup $GCP_DOMAIN
nslookup test.$GCP_DOMAIN
```

### Switch to LetsEncrypt Prod

Adapt the settings in the configuration files with the following:

```bash
sed -i 's/letsencrypt-staging/letsencrypt-prod/g' ~/kkp/values.yaml
sed -i 's/letsencrypt-staging/letsencrypt-prod/g' ~/kkp/kubermatic.yaml
sed -i 's/skipTokenIssuerTLSVerify: true/skipTokenIssuerTLSVerify: false/g' ~/kkp/kubermatic.yaml
```

Re-run the installer again

```bash
kubermatic-installer --kubeconfig ~/.kube/config \
    --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml

# Verify you are obtain valid certificates from LetsEncrypt
# (Note that it can take up a few minutes to get the certs in ready state)
kubectl get certs -A

# Verify everyting is running smoothly
# (Note that the pods kubermatic-api-XXXXX should be fine)
watch -n 1 kubectl -n kubermatic get pods
```

## Visit your KKP Master Installation

```bash
# The URL
echo $GCP_DOMAIN

# The Email Address
echo $GCP_MAIL

# The password is `password` if you haven't changed it
```

Note, we only installed the master componenents yet, which means the UI is reachable, you cannot create Kubernetes Clusters yet.
