# CertificateSigningRequests

## Create the CSR

```bash
# Create the key
openssl genrsa -out bob.key 2048

# Create the CSR
openssl req -new -key bob.key -out bob.csr -subj "/CN=bob/O=eng"\n

# Copy the content of the CSR into an environment variable
export CSR=$(cat bob.csr | base64 | tr -d '\n')

# Use envsubst the set the CSR into the yaml file
envsubst < bob-csr-template.yaml > bob-csr.yaml

# Apply the CSR
kubectl create -f bob-csr.yaml

# Verify the state of the CSR
kubectl get csr
```

## Approve the CSR

```bash
kubectl certificate approve bob
kubectl get csr
```

## Create a kubeconfig for Bob

```bash
# Store the certificate into the file bob.crt
kubectl get csr bob -o jsonpath='{.status.certificate}' | base64 --decode > bob.crt

# Make a copy of the admins kube config file
cp ~/.kube/config ./my-config.yaml

# Add the user Bob to my-config.yaml
kubectl config set-credentials bob \
  --client-certificate=bob.crt \
  --client-key bob.key \
  --embed-certs \
  --kubeconfig my-config.yaml
```

## Verify your work

Note that Bob has no permissions set up via RBAC yet.

```bash
# Check if you can list pods via your admin user
kubectl get pods

# Check if you cannot list pods via the user bob
kubectl --kubeconfig my-config.yaml get pods

# There is also a kubectl command to verify your permissions
kubectl auth can-i get pods
kubectl auth can-i get pods --as bob
```

## Cleanup
```bash
kubectl delete csr bob
```