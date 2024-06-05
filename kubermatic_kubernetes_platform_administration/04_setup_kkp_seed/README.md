# Installation of the Seed 

```bash
cd ~/04_setup_kkp_seed/
```

## Add the Seed kubeconfig to the Master

```bash
cp $KUBECONFIG ./temp-seed-kubeconfig
kubectl create secret generic seed-kubeconfig -n kubermatic --from-file kubeconfig=./temp-seed-kubeconfig --dry-run=client -o yaml > ~/kkp/seed-kubeconfig-secret.yaml
kubectl apply -f ~/kkp/seed-kubeconfig-secret.yaml
```

## Configure the Seed

Take a look into `~/kkp/seed.yaml`

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
# Store IP of NodePort Proxy into environment variable
export SEED_IP=$(kubectl -n kubermatic get svc nodeport-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Verify that environment variable is set
echo $SEED_IP

make IP=$SEED_IP create_seed_dns_record

# Verify DNS record
nslookup test.kubermatic.$DOMAIN
```

Congrats your KKP installation is now ready for use!!!

Jump > [Home](../README.md) | Previous > [Setup KKP Master](../03_setup_kkp_master/README.md) | Next > [Create User Cluster](../05_create_user_cluster/README.md)
