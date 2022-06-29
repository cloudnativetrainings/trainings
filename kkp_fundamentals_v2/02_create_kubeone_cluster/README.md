
# create master
make create_cluster

# small stuff
mkdir -p ~/.kube
cp ~/kubeone/kkp-admin-kubeconfig ~/.kube/config
kubectl -n kube-system scale md master-pool1 --replicas 5
kubectl get nodes
source <(kubectl completion bash)
