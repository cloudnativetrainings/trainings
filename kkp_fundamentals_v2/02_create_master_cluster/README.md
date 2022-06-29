
# create master
make create_master

# small stuff
mkdir ~/.kube
cp ~/kubeone/master-kubeconfig ~/.kube/config
kubectl -n kube-system scale md master-pool1 --replicas 5
kubectl get nodes

# k8s
source <(kubectl completion bash)






