check UI
 => limited upgrade possibilities

add to kubermatic.yaml
```yaml
  versions:
    versions:
      - v1.20.13
      - v1.20.14
      - v1.21.8
      - v1.22.5
      - v1.22.10
      - v1.22.11
    default: '1.21.8'
```

kubectl apply -f ~/kkp/kubermatic.yaml

<!-- Slides kubernetes components version diffs -->

## UI

upgrade cluster
upgrade machine deployments

=> watch control plane and md in UI

<!-- TODO tip kubermatic-installer print -->

=> check in UI


# do it on the terminal

## change control plane

kubectl edit cluster asdf

=> check in UI

## change worker nodes

=> download user cluster kubeconfig
=> drag and drop into cloud shell explorer
=> open a new shell

export KUBECONFIG=~/kubeconfig-admin-

kubectl get nodes

=> check nodes version

kubectl -n kube-system edit md sad-noyce

=> change version

watch -n 1 kubectl get nodes

!!! switch back to other termianl




