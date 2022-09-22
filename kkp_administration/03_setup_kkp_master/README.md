# Setup KKP Master

```bash
cd ~/03_setup_kkp_master
```

## Configure KKP

### Exchange URLs

```bash
sed -i 's/cluster.example.dev/'$DOMAIN'/g' ~/kkp/kubermatic.yaml
sed -i 's/cluster.example.dev/'$DOMAIN'/g' ~/kkp/values.yaml
```

### Generate Secrets

Create random secrets via 
```bash
cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32
```

for the following fields in the file `values.yaml`
* `dex.clients[kubermatic].secret`
* `dex.clients[kubermaticIssuer].secret`

and for the following fields in the file `kubermatic.yaml`
* `auth.issuerCookieKey`
* `auth.serviceAccountKey`

Copy the secret from `dex.clients[kubermaticIssuer].secret` from the file `values.yaml` into `auth.issuerClientSecret` field of the file `kubermatic.yaml`.

### Create static login credentials

```bash
sed -i 's/kubermatic@example.com/'$MAIL'/g' ~/kkp/values.yaml
```

### Generate uuid for telemetry

```bash
sed -i 's/uuid: \"\"/uuid: \"'$(uuidgen -r)'\"/g' ~/kkp/values.yaml
```

### Adapt Minio Settings

Change the minio settings to the following:

```yaml
minio:
  storeSize: '10Gi'
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

## Install KKP

```bash
kubermatic-installer --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml

# Verify everyting is running smoothly 
# (Note that the pods kubermatic-api-XXXXX will not run smoothly due to DNS is not setup yet)
kubectl get pods -A
```

## Apply the Production ClusterIssuer

```bash
# Change the email address
sed -i 's/TODO-STUDENT-EMAIL@loodse.training/'$MAIL'/g' ~/kkp/clusterissuer.yaml

kubectl apply -f ~/kkp/clusterissuer.yaml
```

## Configure DNS

Copy the IP address from the kubermatic-installer output and make use of it like the following:

```bash
# Store IP of Loadbalancer into environment variable
export INGRESS_IP=$(kubectl -n nginx-ingress-controller get service nginx-ingress-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Verify that environment variable is set
echo $INGRESS_IP

make IP=$INGRESS_IP create_dns_records

# Verify DNS records
nslookup $DOMAIN
nslookup test.$DOMAIN
```

## Switch to LetsEncrypt Prod

Adapt the settings in the configuration files with the following:

```bash
sed -i 's/letsencrypt-staging/letsencrypt-prod/g' ~/kkp/values.yaml
sed -i 's/letsencrypt-staging/letsencrypt-prod/g' ~/kkp/kubermatic.yaml
sed -i 's/skipTokenIssuerTLSVerify: true/skipTokenIssuerTLSVerify: false/g' ~/kkp/kubermatic.yaml
```

Re-run the installer again

```bash
kubermatic-installer --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml     

# Verify everyting is running smoothly
kubectl get pods -A

# Verify you are obtain valid certificates from LetsEncrypt
# (Note that it can take up a few minutes to get the certs in ready state)
kubectl get certs -A
```

## Visit your KKP Master Installation

```bash
# The URL
echo $DOMAIN

# The Email Address
echo $MAIL

# The password is `password` if you haven't changed it
```

Jump > [Home](../README.md) | Previous > [Create KubeOne Cluster](../02_create_kubeone_cluster/README.md) | Next > [Setup KKP Seed](../04_setup_kkp_seed/README.md)
