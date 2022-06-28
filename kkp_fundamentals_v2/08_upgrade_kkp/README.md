
# breaking changes

https://github.com/kubermatic/kubermatic/blob/master/CHANGELOG.md

https://docs.kubermatic.com/kubermatic/master/tutorials_howtos/upgrading/

https://docs.kubermatic.com/kubermatic/master/architecture/compatibility/supported_versions/


# install new kkp release

check a minor release upgrade here: https://github.com/kubermatic/kubermatic/releases

make KKP_VERSION_NEW=2.20.4 setup_new_master_folder

# update

export KUBECONFIG=~/master/kubeone/master-kubeconfig

kubermatic-installer-2.20.4 --charts-directory ~/master/kkp-2.20.4/charts deploy \
    --config ~/master/kkp-2.20.4/kubermatic.yaml \
    --helm-values ~/master/kkp-2.20.4/values.yaml
    

## verify everything got updated

export KUBECONFIG=~/master/kubeone/master-kubeconfig
kubectl -n kubermatic get pods

export KUBECONFIG=~/seed/kubeone/seed-kubeconfig
kubectl -n kubermatic get pods
