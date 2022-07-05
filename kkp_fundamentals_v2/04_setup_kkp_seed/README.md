# Installation of the Seed 

```bash
cd ~/04_setup_kkp_seed/
```

<!-- TODO try via applying the CRDs manually and helm charts -->

## Add the Seed kubeconfig to the Master

```bash
cp $KUBECONFIG ./temp-seed-kubeconfig
kubectl create secret generic seed-kubeconfig -n kubermatic --from-file kubeconfig=./temp-seed-kubeconfig --dry-run=client -o yaml > ~/kkp/seed-kubeconfig-secret.yaml
kubectl apply -f ~/kkp/seed-kubeconfig-secret.yaml
```

## Configure the Seed

Copy the following content into `~/kkp/seed.yaml`

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

## Apply the Seed

```bash
kubectl apply -f ~/kkp/seed.yaml

# Verify installation
kubectl -n kubermatic get pods

# Verify that the following pods are running
# * kubermatic-seed-controller-manager-...
# * nodeport-proxy-...
# * seed-proxy-kubermatic-...

# Re-run the installer with kubermatic-seed option
kubermatic-installer --charts-directory ~/kkp/charts deploy kubermatic-seed \
  --config ~/kkp/kubermatic.yaml \
  --helm-values ~/kkp/values.yaml  
```

## Create DNS entries for Seed

```bash
export kubectl -n kubermatic get svc nodeport-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

# Store IP of NodePort Proxy into environment variable
export SEED_IP=$(kubectl -n kubermatic get svc nodeport-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Verify that environment variable is set
echo $SEED_IP

make IP=$SEED_IP create_dns_records

# Verify DNS record
nslookup test.kubermatic.$DOMAIN
```

Congrats your KKP installation is now ready for use!!!