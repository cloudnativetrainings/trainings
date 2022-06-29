
# breaking changes

https://github.com/kubermatic/kubermatic/blob/master/CHANGELOG.md

https://docs.kubermatic.com/kubermatic/master/tutorials_howtos/upgrading/

https://docs.kubermatic.com/kubermatic/master/architecture/compatibility/supported_versions/


# install new kkp release

<!-- TODO may overwrite the old installer and charts -->

check a minor release upgrade here: https://github.com/kubermatic/kubermatic/releases

make KKP_VERSION_NEW=2.20.4 install_new_kkp

kubermatic-installer --charts-directory ~/kkp/charts version

# update

kubermatic-installer --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml

## verify everything got updated

kubectl -n kubermatic get pods

=> Check UI