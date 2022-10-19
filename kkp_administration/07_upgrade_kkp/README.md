# Upgrade KKP

```bash
cd ~/07_upgrade_kkp
```

## Install the new KKP version

```bash
make KKP_VERSION_NEW=2.21.2 install_new_kkp

# Verify the upgraded version
kubermatic-installer --charts-directory ~/kkp/charts version
```

## Update KKP

```bash
# Update Master Components
kubermatic-installer --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml

# Update Seed Components
kubermatic-installer --charts-directory ~/kkp/charts deploy kubermatic-seed \
  --config ~/kkp/kubermatic.yaml \
  --helm-values ~/kkp/values.yaml     

# Verify KKP got updated
kubectl -n kubermatic get pods
```    

Jump > [Home](../README.md) | Previous > [Upgrade User Cluster](../06_upgrade_user_cluster/README.md) | Next > [Addons](../08_addons/README.md)
