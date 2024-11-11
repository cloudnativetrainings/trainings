# Installation of the Seed

In this lab you will create a KKP Seed Cluster.

```bash
cd ~/03_setup_kkp_seed/
```

## Add the Seed kubeconfig to the Master

For the KKP Seed Components being able to communicate with the KKP Master Components you have to create a secret containing the kubeconfig of the Master Cluster. In our case the Seed and Master Components are running in the same cluster.

```bash
cp ~/kubeone/kkp-master-seed-cluster-kubeconfig ~/.tmp/temp-seed-kubeconfig
kubectl create secret generic seed-kubeconfig -n kubermatic --from-file kubeconfig=~/.tmp/temp-seed-kubeconfig --dry-run=client -o yaml > ~/kkp/seed-kubeconfig-secret.yaml
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
kubermatic-installer --kubeconfig ~/.kube/config \
    --charts-directory ~/kkp/charts deploy kubermatic-seed \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml
```

## Create DNS entries for Seed

Also the communication from the Master Components towards the Control Plane components of the User Clusters, running in the Seed Cluster, has to be encrypted. Therefore we configure a new wildcard DNS entry.

```bash
# Store IP of NodePort Proxy into environment variable
export SEED_IP=$(kubectl -n kubermatic get svc nodeport-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Verify that environment variable is set
echo $SEED_IP

make IP=$SEED_IP create_seed_dns_record

# Verify DNS record
nslookup test.kubermatic.$GCP_DOMAIN
```

Congrats your KKP installation is now ready for use!!!
