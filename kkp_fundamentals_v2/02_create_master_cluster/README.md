
# create master
make create_master

# small stuff
export KUBECONFIG=~/master/kubeone/master-kubeconfig
source <(kubectl completion bash)
kubectl -n kube-system scale md master-pool1 --replicas 3
kubectl get nodes


