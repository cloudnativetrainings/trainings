
# intro

https://docs.kubermatic.com/kubermatic/v2.20/architecture/concept/kkp-concepts/addons/

find it in the UI

# UI

install metrics-server

check in Dashboard

## accessible addons are defaulted
https://github.com/kubermatic/kubermatic/blob/master/docs/zz_generated.kubermaticConfiguration.yaml#L10-L15

https://github.com/kubermatic/kubermatic/blob/master/docs/zz_generated.kubermaticConfiguration.yaml#L323-L392

https://github.com/kubermatic/kubermatic/blob/master/pkg/controller/operator/defaults/defaults.go#L358-L372

# custom addons

## create yaml manifests

check pod.yaml in my-addon folder

## create addons-container
<!--  -->

## change kubermaticconfiguration
<!--  -->

## create AddOnConfig

cat logo_78x78.png | base64 -w0 > logo.tmp

=> insert into logo section







<!-- TODO ensure that the one and only kubermaticconfiguration is used everywhere -->

<!-- kubectl -n kubermatic get kubermaticconfiguration kubermatic  -o yaml => is in master -->



{SEED}

kubectl -n kubermatic get pod kubermatic-seed-controller-manager-7d9f8f9bd8-hbv7f  -o yaml
kubectl -n kubermatic exec kubermatic-seed-controller-manager-7d9f8f9bd8-hbv7f  -- ls -alh /opt/addons




