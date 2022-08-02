
# problem

kubectl exec -it my-suboptimal-pod -- touch /some-file.txt
kubectl exec -it my-suboptimal-pod -- ls -alh /some-file.txt

kubectl exec -it my-suboptimal-pod -- touch /host/root/some-file.txt
ls -alh /root

# fix it

securityContext:
  readOnlyRootFilesystem: true

volumeMounts readOnly: true

kubectl apply -f pod.yaml --force

kubectl exec -it my-suboptimal-pod -- touch /some-file.txt
kubectl exec -it my-suboptimal-pod -- ls -alh /some-file.txt

kubectl exec -it my-suboptimal-pod -- touch /host/root/some-file.txt
ls -alh /root
