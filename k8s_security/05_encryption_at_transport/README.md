# Encryption at Transport

## Verify Certs

### Certs for Master Components

```bash
ls -alh /etc/kubernetes/pki/
```

### Cert for Worker Nodes

```bash
cat /etc/kubernetes/kubelet.conf
```

### Cert for Developer

```bash
cat ~/.kube/config
```

## Check Certs

```bash
# verify expiration dates of certs
kubeadm certs check-expiration

# check renew possibilities of kubeadm
kubeadm certs renew --help

# verify expiration date via openssl
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout
```
