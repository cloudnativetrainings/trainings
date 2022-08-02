# image registries
kubectl apply -f image-registry-cluster-policy.yaml
kubectl delete pod my-suboptimal-pod 
kubectl apply -f pod.yaml
=> expect error

<!-- helm -n kyverno uninstall kyverno -->
<!-- TODO does not work very properly -->
<!-- kubectl delete -f image-registry-cluster-policy.yaml -->
<!-- kubectl delete ns kyverno -->
kubectl delete -f 10_kyverno/image-registry-cluster-policy.yaml 

kubectl apply -f pod.yaml
=> should work again

