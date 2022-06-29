
# create project

# without preset

base64 -w0 ~/secrets/key.json

ssd disk
n1-standard-2
number of nodes!!!
<!-- TODO how to configure that 3 is default??? -->
replicas 3!!!

an 2 times older kubernetes version for being able to upgrade

## cli on seed

kubectl get ns

=> delete ETCD

kubectl get cluster pgrwrdqgzj -o yaml

=> download user cluster kubeconfig
=> drag and drop into cloud shell explorer

export KUBECONFIG=~/Downloads/kubeconfig-admin-v7bx9dhwgm  

!!! switch back to other termianl

kubectl delete cluster pgrwrdqgzj 

# Provider Presets & Cluster Templates

## create preset

Admin Panel

Create Preset

base64 -w0 ~/secrets/key.json

## create cluster Template


kubectl get preset gce  -o yaml

kubectl get clustertemplate wz6tg725vb  -o yaml

## create cluster

<!-- TODO -->
# create cluster via BYO

<!-- TODO -->
# create cluster via api

<!-- HINT to zz generated files https://github.com/kubermatic/kubermatic/tree/master/docs -->