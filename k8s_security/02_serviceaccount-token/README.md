
# getting

kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt

<!-- journalctl -u kubelet -->

TOKEN=$(kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)
kubectl exec -it my-suboptimal-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt > ca.crt

curl -s $API_SERVER/api/v1/namespaces/default/pods --header "Authorization: Bearer $TOKEN" --cacert ca.crt
=> should work

kubectl get clusterrolebindings

=> check the default my-suboptimal-clusterrolebinding

kubectl delete clusterrolebinding my-suboptimal-clusterrolebinding

... curl again
=> should not work

# check kubadm
cat /etc/kubernetes/manifests/kube-apiserver.yaml 

=> check authorization mode
