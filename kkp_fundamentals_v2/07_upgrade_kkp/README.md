# Upgrade KKP

```bash
cd ~/07_upgrade_kkp
```

## Install the new KKP version

```bash
make KKP_VERSION_NEW=2.20.4 install_new_kkp

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

<!-- TODO slides# breaking changes
https://github.com/kubermatic/kubermatic/blob/master/CHANGELOG.md
https://docs.kubermatic.com/kubermatic/master/tutorials_howtos/upgrading/
https://docs.kubermatic.com/kubermatic/master/architecture/compatibility/supported_versions/ 
check a minor release upgrade here: https://github.com/kubermatic/kubermatic/releases
-->
