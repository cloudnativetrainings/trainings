
# install new kkp release

check a minor release upgrade here: https://github.com/kubermatic/kubermatic/releases

make KKP_VERSION_NEW=2.20.4 install_new_kkp

# update

<!-- TODO install kkp version already at the beginning -->

<!-- also add to reconnect and destroy -->

<!-- charts directory and config files -->
<!-- TODO create new structures in ~/master/kkp-newversion -->

kubermatic-installer-2.20.4 --charts-directory ~/.tmp/kkp-2.20.4/charts deploy --config kubermatic.yaml --helm-values values.yaml 
