
# create secret

kubectl create secret generic my-secret --from-literal password=password123

kubectl get secret my-secret -o yaml
kubectl get secret my-secret -o jsonpath='{.data.password}' | base64 -d

# use secret
=> add secret volume in pod
kubectl apply -f pod.yaml --force

# view plaintext secret in pod
kubectl exec -it my-suboptimal-pod -- ls -alh /secret/
kubectl exec -it my-suboptimal-pod -- cat /secret/password

# view plaintext secret on host
df | grep tmpfs
cat /var/lib/kubelet/pods/c61079ab-eed7-4f79-b87b-b01c62e54d70/volumes/kubernetes.io~secret/secret-data/password

