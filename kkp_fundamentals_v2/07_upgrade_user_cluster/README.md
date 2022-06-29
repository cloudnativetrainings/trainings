
on master

kubectl -n kubermatic get kubermaticconfiguration kubermatic -o yaml > kubermatic-configuration.yaml

add to yaml
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

<!-- TODO bug https://github.com/kubermatic/kubermatic/issues/10204

=> ensure that versions section is in the kubermatic-configuration!!!

-->

kubectl apply -f kubermatic-configuration.yaml

check UI

## UI

upgrade cluster
upgrade machine deployments

=> watch control plane and md in UI

<!-- TODO tip kubermatic-installer print -->

=> check in UI


# do it on the terminal

## change control plane

export KUBECONFIG=~/seed/kubeone/seed-kubeconfig

on seed

kubectl get cluster bf44dwhcck -o yaml > cluster.yaml

=> change version

kubectl apply -f cluster.yaml

=> check in UI

## change worker nodes

=> download kubeconfig

kubectl -n kube-system get md musing-poitras-worker-wtkc4j -o yaml > md.yaml  

=> change version

kubectl apply -f md.yaml

watch -n 1 kubectl get nodes




