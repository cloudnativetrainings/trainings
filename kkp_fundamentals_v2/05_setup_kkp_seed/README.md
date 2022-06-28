
# apply storageclasses
kubectl apply -f ~/seed/kkp/storageclass-fast.yaml
kubectl apply -f ~/seed/kkp/storageclass-backup.yaml

# run installer for creation of CRDs?
kubermatic-installer deploy kubermatic-seed \
  --config ~/seed/kkp/kubermatic.yaml \
  --helm-values ~/seed/kkp/values.yaml \
  --charts-directory ~/seed/kkp/charts

<!-- TODO charts dir problem??? -->

# configure seed at master

<!-- TODO try via applying the CRDs manually and helm charts -->

## secret
cp $KUBECONFIG ./temp-seed-kubeconfig
kubectl create secret generic seed-kubeconfig -n kubermatic --from-file kubeconfig=./temp-seed-kubeconfig --dry-run=client -o yaml > ~/seed/kkp/seed-kubeconfig-secret.yaml

export KUBECONFIG=~/master/kubeone/master-kubeconfig
kubectl apply -f seed-kubeconfig-secret.yaml

## seed configuration

seed config
```yaml
country: DE
  location: Frankfurt
  datacenters:
    gcp-frankfurt:
      country: DE
      location: EU (Frankfurt)
      spec:
        gcp:
          region: "europe-west3"
          regional: false
          zone_suffixes: [a, b, c]
```

kubectl apply -f ~/seed/kkp/seed.yaml

# adapt minio settings
in values.yaml

```yaml
minio:
  storeSize: '10Gi'
  storageClass: kubermatic-backup
  credentials:
    accessKey: "reoshe9Eiwei2ku5foB6owiva2Sheeth"
    secretKey: "rooNgohsh4ohJo7aefoofeiTae4poht0cohxua5eithiexu7quieng5ailoosha8"
```

# apply seed
<!-- TODO copy charts directory -->
<!-- TODO bug due charts directory does not work -->
<!-- TODO bug due charts directory does not work -->

export KUBECONFIG=~/seed/kubeone/seed-kubeconfig

kubermatic-installer deploy kubermatic-seed \
  --config ~/seed/kkp/kubermatic.yaml \
  --helm-values ~/seed/kkp/values.yaml \
  --charts-directory ~/seed/kkp/charts

# DNS entry for seed

*.kubermatic.student-00-kkp-admin-training.loodse.training.  IN  A  34.159.48.164

make IP=34.159.159.191 create_dns_records

