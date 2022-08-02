
# master communication
ls -alh /etc/kubernetes/pki/

# worker to master communication
cat /etc/kubernetes/kubelet.conf

# dev to apiserver communication
cat ~/.kube/config

# update certs
kubeadm certs check-expiration
kubeadm certs renew --help
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout

