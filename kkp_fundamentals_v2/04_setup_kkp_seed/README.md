
# apply storageclasses
kubectl apply -f ~/seed/kkp/storageclass-backup.yaml

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

# configure seed at master

<!-- TODO try via applying the CRDs manually and helm charts -->

## secret
cp $KUBECONFIG ./temp-seed-kubeconfig
kubectl create secret generic seed-kubeconfig -n kubermatic --from-file kubeconfig=./temp-seed-kubeconfig --dry-run=client -o yaml > ~/kkp/seed-kubeconfig-secret.yaml

kubectl apply -f ~/kkp/seed-kubeconfig-secret.yaml

## seed configuration

datacenter and seed-kubeconfig secret

seed config
```yaml
apiVersion: kubermatic.k8c.io/v1
kind: Seed
metadata:
  name: kubermatic
  namespace: kubermatic
spec:
  country: DE
  location: Frankfurt
  datacenters:
    gcp-frankfurt:
      country: DE
      location: Frankfurt
      spec:
        gcp:
          region: "europe-west3"
          regional: false
          zoneSuffixes: [a, b, c]
    byo:
      country: DE
      location: Frankfurt
      node: {}
      spec:
        bringyourown: {}
  kubeconfig:
    name: seed-kubeconfig
    namespace: kubermatic        
```

kubectl apply -f ~/kkp/seed.yaml

# apply seed

export KUBECONFIG=~/seed/kubeone/seed-kubeconfig

=> check if stuff is running in kubermatic namespace
kubectl -n kubermatic get pods

kubermatic-installer --charts-directory ~/kkp/charts deploy kubermatic-seed \
  --config ~/kkp/kubermatic.yaml \
  --helm-values ~/kkp/values.yaml  
  
# DNS entry for seed

*.kubermatic.student-00-kkp-admin-training.loodse.training.  IN  A  34.159.48.164

<!-- TODO maybe other make target name -->
make IP=35.242.246.120 create_dns_records

<!-- TODO student-00 does not work everywhere -->
nslookup test.kubermatic.student-01-kkp-admin-training.loodse.training

gcloud dns record-sets list --zone student-01-kkp-admin-training