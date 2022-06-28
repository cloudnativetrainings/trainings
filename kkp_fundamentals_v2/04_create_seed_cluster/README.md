# create master
make create_seed

# small stuff
export KUBECONFIG=~/seed/kubeone/seed-kubeconfig
kubectl -n kube-system scale md seed-pool1 --replicas 3
kubectl get nodes
