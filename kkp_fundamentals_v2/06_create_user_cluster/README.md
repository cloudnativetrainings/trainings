
# without preset

base64 -w0 ~/secrets/key.json

ssd disk
n1-standard2
number of nodes!!!

an 2 times older kubernetes version for being able to upgrade

# create preset for seed

<!-- TODO rename to preset-gce.yaml -->

export KUBECONFIG=~/seed/kubeone/seed-kubeconfig

base64 -w0 ~/secrets/key.json

kubectl apply -f ~/seed/kkp/charts/kubermatic-operator/crd/crd-presets.yaml

kubectl apply -f ~/seed/kkp/preset.yaml

<!-- TODO -->

download kubeconfig

create cluster via api

kubectl get cluster
kubectl describe cluster

# cli

kubectl get cluster pgrwrdqgzj -o yaml

kubectl delete cluster pgrwrdqgzj 

