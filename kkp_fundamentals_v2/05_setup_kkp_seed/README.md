
# apply storageclasses
kubectl apply -f ~/seed/kkp/storageclass-fast.yaml
kubectl apply -f ~/seed/kkp/storageclass-backup.yaml

# adapt minio settings

<!-- TODO do this in master -->

in values.yaml

```yaml
minio:
  storeSize: '10Gi'
  storageClass: kubermatic-backup
  credentials:
    accessKey: "reoshe9Eiwei2ku5foB6owiva2Sheeth"
    secretKey: "rooNgohsh4ohJo7aefoofeiTae4poht0cohxua5eithiexu7quieng5ailoosha8"
```

<!-- TODO delete charts kubermatic.yaml and values.yaml in seed -->

<!-- TODO we have to have the kubermatic.yaml and values.yaml from the master -->

<!-- TODO maybe keep task specific files in task -->

# run installer for creation of CRDs?
kubermatic-installer --charts-directory ~/master/kkp/charts deploy kubermatic-seed \
  --config ~/master/kkp/kubermatic.yaml \
  --helm-values ~/master/kkp/values.yaml  

# configure seed at master

<!-- TODO try via applying the CRDs manually and helm charts -->

## secret
cp $KUBECONFIG ./temp-seed-kubeconfig
kubectl create secret generic seed-kubeconfig -n kubermatic --from-file kubeconfig=./temp-seed-kubeconfig --dry-run=client -o yaml > ~/seed/kkp/seed-kubeconfig-secret.yaml

export KUBECONFIG=~/master/kubeone/master-kubeconfig
kubectl apply -f ~/seed/kkp/seed-kubeconfig-secret.yaml

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

kubectl apply -f ~/seed/kkp/seed.yaml

# apply seed

export KUBECONFIG=~/seed/kubeone/seed-kubeconfig

=> check if stuff is running in kubermatic namespace
kubectl -n kubermatic get pods

kubermatic-installer --charts-directory ~/master/kkp/charts deploy kubermatic-seed \
  --config ~/master/kkp/kubermatic.yaml \
  --helm-values ~/master/kkp/values.yaml  
  
# DNS entry for seed

*.kubermatic.student-00-kkp-admin-training.loodse.training.  IN  A  34.159.48.164

make IP=34.159.2.10 create_dns_records

<!-- TODO student-00 does not work everywhere -->
nslookup test.kubermatic.student-01-kkp-admin-training.loodse.training

gcloud dns record-sets list --zone student-01-kkp-admin-training