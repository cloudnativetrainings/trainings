# Upgrade KKP

In this lab you will upgrade KKP.

```bash
cd ~/07_upgrade_kkp
```

## Pre Steps

### Check the Release Notes

Before upgrading KKP please **always** take a look into the release notes. Eg for 2.26 you can find them [here](https://docs.kubermatic.com/kubermatic/v2.26/release-notes/). There can be situations in which actions from your side are required.

### Check the supported Kubernetes Versions

Furthermore we will remove our Kubernetes Versions Settings again, to go with the defaults. You can find the supported versions [here](https://docs.kubermatic.com/kubermatic/main/architecture/compatibility/supported-versions/).

Remove the following in the file `kubermatic.yaml` in the `spec` section (mind the proper indent):

```bash
versions:
  versions:
    - v1.29.1
    - v1.29.4
  default: "1.29.1"
```

And apply this change again.

```bash
kubectl apply -f ~/kkp/kubermatic.yaml
```

## Install the new KKP version

```bash
make install_new_kkp

# Verify the KKP version
kubermatic-installer --version
```

## Update KKP

```bash
# Update Master Components
kubermatic-installer --kubeconfig ~/.kube/config \
    --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml

# Update Seed Components
kubermatic-installer --kubeconfig ~/.kube/config --charts-directory ~/kkp/charts deploy kubermatic-seed \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml
```

## Verification of Upgrade

### Via CLI

```bash
# Verify everything is running again
watch -n 1 kubectl -n kubermatic get pods
```

### Via UI

- Verify the version in the UI, you can find the KKP version number on the left below of the UI.
- Verify the newly available Kubernetes Versions within your Cluster via the Uprade DropDown.
