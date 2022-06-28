
# install new kkp release

check a minor release upgrade here: https://github.com/kubermatic/kubermatic/releases

make KKP_VERSION_NEW=2.20.4 setup_new_master_folder

# update

<!-- TODO install kkp version already at the beginning -->

<!-- also add to reconnect and destroy -->

<!-- charts directory and config files -->
<!-- TODO create new structures in ~/master/kkp-newversion -->

kubermatic-installer-2.20.4 deploy \
    --config ~/master/kkp-2.20.4/kubermatic.yaml \
    --helm-values ~/master/kkp-2.20.4/values.yaml \
    --charts-directory ~/master/kkp-2.20.4/charts


<!-- TODO upgrade seed??? -->