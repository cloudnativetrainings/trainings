make create_master
export KUBECONFIG=~/master/kubeone/master-kubeconfig
kubectl get nodes

source <(kubectl completion bash)
