
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

docker build -t gcr.io/student-01-kkp-admin-training/kkp-addons:v2.20.4-kkp-admin .
docker push gcr.io/student-01-kkp-admin-training/kkp-addons:v2.20.4-kkp-admin


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

kubectl apply -f kubermatic.yaml

kubectl describe pod kubermatic-seed-controller-manager-57f4458d65-nsfd9
kubectl exec -it kubermatic-seed-controller-manager-57f4458d65-nsfd9 -- sh
ls -alh /opt/addons/kubernetes

## create AddOnConfig

<!-- maybe makefile -->


cat logo_78x78.png | base64 -w0 > logo.tmp

=> insert into logo section


<!--  -->

<!-- TODO maybe do this at the installation phase of kkp -->
kubectl apply -f ~/master/kkp-2.20.4/charts/kubermatic-operator/crd/
kubectl apply -f my-addon




<!-- TODO ensure that the one and only kubermaticconfiguration is used everywhere -->

<!-- kubectl -n kubermatic get kubermaticconfiguration kubermatic  -o yaml => is in master -->



export KUBECONFIG=~/seed/kubeone/seed-kubeconfig

kubectl -n kubermatic get pod kubermatic-seed-controller-manager-7d9f8f9bd8-hbv7f  -o yaml
kubectl -n kubermatic exec kubermatic-seed-controller-manager-7d9f8f9bd8-hbv7f  -- ls -alh /opt/addons
kubectl -n kubermatic exec -it kubermatic-seed-controller-manager-7d9f8f9bd8-hbv7f -- sh



<!-- TODO now I am completely confused -->


