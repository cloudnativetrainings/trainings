
# apply storageclasses

# adapt minio settings
in values.yaml

```yaml
minio:
  storeSize: '10Gi'
  storageClass: kubermatic-backup
  # access key/secret for the exposed minio S3 gateway
  credentials:
    # access key length should be at least 3 characters
    accessKey: "reoshe9Eiwei2ku5foB6owiva2Sheeth"
    # secret key length should be at least 8 characters
    secretKey: "rooNgohsh4ohJo7aefoofeiTae4poht0cohxua5eithiexu7quieng5ailoosha8"
```


<!-- TODO -->
apply seed secret and seed in master prio of installer

# apply seed
<!-- TODO copy charts directory -->
<!-- TODO bug due charts directory does not work -->

kubermatic-installer deploy kubermatic-seed --config ~/master/kkp/kubermatic.yaml --helm-values ~/master/kkp/values.yaml 

# create kubeconfig secret from seed

## seed
cp $KUBECONFIG ./temp-seed-kubeconfig
kubectl create secret generic seed-kubeconfig -n kubermatic --from-file kubeconfig=./temp-seed-kubeconfig --dry-run=client -o yaml > ./seed.kubeconfig.secret.yaml

## master

kubectl -n kubermatic apply -f seed.kubeconfig.secret.yaml

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

# DNS entry for seed

*.kubermatic.student-00-kkp-admin-training.loodse.training.  IN  A  34.159.48.164


<!-- TODO ensure sc on master is also not immediate!!! -->