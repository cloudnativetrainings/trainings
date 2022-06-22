export KUBECONFIG=~/seed/kubeone/seed-kubeconfig

# increase worker nodes
kubectl -n kube-system scale md seed-pool1 --replicas 3

<!-- TODO -->
values.yaml kubermatic.yaml and charts from master
apply backup storageclass
minio config like https://github.com/kubermatic-labs/trainings/tree/master/kkp_fundamentals/04-add-seed-cluster


kubermatic-installer deploy kubermatic-seed --config ~/master/kkp/kubermatic.yaml --helm-values ~/master/kkp/values.yaml --storageclass gce
