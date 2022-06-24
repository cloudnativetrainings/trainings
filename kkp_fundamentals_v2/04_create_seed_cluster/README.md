make create_seed
export KUBECONFIG=~/seed/kubeone/seed-kubeconfig
<!-- source <(kubectl completion bash) -->
kubectl -n kube-system scale md seed-pool1 --replicas 3
kubectl get nodes
