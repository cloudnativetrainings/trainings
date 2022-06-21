
make prepare

=> check files in master/kubeone and seed/kubeone

make create_master
export KUBECONFIG=~/master/kubeone/master-kubeconfig
kubectl get nodes

make create_seed
export KUBECONFIG=~/seed/kubeone/seed-kubeconfig
kubectl get nodes
