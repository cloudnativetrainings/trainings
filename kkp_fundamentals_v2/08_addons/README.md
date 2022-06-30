
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

## create docker container

<!-- TODO student-01 -->
<!-- maybe makefile -->

cd into folder

docker build -t gcr.io/student-01-kkp-admin-training/kkp-addons:v2.20.4-kkp-admin .
docker push gcr.io/student-01-kkp-admin-training/kkp-addons:v2.20.4-kkp-admin

=> verify in https://console.cloud.google.com/gcr/images/student-01-kkp-admin-training?project=student-01-kkp-admin-training


## change kubermaticconfiguration

```yaml
  userCluster:
    addons:
      dockerRepository: gcr.io/student-01-kkp-admin-training/kkp-addons
      dockerTagSuffix: "kkp-admin"
  api:
    accessibleAddons:
      - my-addon
```

kubectl apply -f ~/kkp/kubermatic.yaml

kubectl -n kubermatic get pods
kubectl -n kubermatic describe pod kubermatic-seed-controller-manager-57f4458d65-nsfd9
kubectl -n kubermatic exec -it kubermatic-seed-controller-manager-57f4458d65-nsfd9 -- sh

[in container] ls -alh /opt/addons
=> find my-addon

## create AddOnConfig

<!-- maybe makefile -->


cat logo_32x32.png | base64 -w0 > logo.tmp

=> insert into logo section

<!-- TODO maybe do this at the installation phase of kkp -->
kubectl apply -f ~/kkp/charts/kubermatic-operator/crd/crd-addon-configs.yaml
kubectl apply -f ~/kkp/charts/kubermatic-operator/crd/crd-addons.yaml
kubectl apply -f ~/kkp/my-addon.yaml

check in UI
apply add-on
check in Dashboard

<!-- TODO addon formspec -->
