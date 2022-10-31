# Authentication

In the training, we will learn about create authentication configuration using CSR, certificate and kubeconfig for a user to grant access over specific k8s cluster.

>Navigate to the folder `25_authentication` from CLI, before you get started. 

## Create the CSR

* Create the key

  ```bash
  openssl genrsa -out bob.key 2048
  ```

* Create the CSR

  ```bash
  openssl req -new -key bob.key -out bob.csr -subj "/CN=bob/O=eng"\n
  ```

* Copy the content of the CSR into an environment variable

  ```bash
  export CSR=$(cat bob.csr | base64 | tr -d '\n')
  ```

* Use envsubst the set the CSR into the yaml file

  ```bash
  envsubst < bob-csr-template.yaml > bob-csr.yaml
  ```

* Apply the CSR

  ```bash
  kubectl create -f bob-csr.yaml
  ```

* Verify the state of the CSR

  ```bash
  kubectl get csr
  ```

## Approve the CSR

```bash
kubectl certificate approve bob
kubectl get csr
```

## Create a kubeconfig for Bob

* Store the certificate into the file bob.crt

  ```bash
  kubectl get csr bob -o jsonpath='{.status.certificate}' | base64 --decode > bob.crt
  ```

* Make a copy of the admins kube config file

  ```bash
  cp ~/.kube/config ./my-config.yaml
  ```

* Add the user Bob to my-config.yaml

  ```bash
  kubectl config set-credentials bob \
  --client-certificate=bob.crt \
  --client-key bob.key \
  --embed-certs \
  --kubeconfig my-config.yaml
  ```

* Set the current context and user

  ```bash
  CURRENT_CONTEXT=$(kubectl config current-context --kubeconfig my-config.yaml)
  kubectl config set-context bob --cluster=$CURRENT_CONTEXT --user=bob
  kubectl config use-context bob --kubeconfig my-config.yaml
  ```

## Verify your work

>Note that Bob has no permissions set up via RBAC yet.

# Check if you can list pods via your admin user

  ```bash
  kubectl get pods
  ```

* Check if you cannot list pods via the user bob

  ```bash
  kubectl --kubeconfig my-config.yaml get pods
  ```

* There is also a kubectl command to verify your permissions

  ```bash
  kubectl auth can-i get pods
  kubectl auth can-i get pods --as bob
  ```

## Cleanup

```bash
kubectl delete csr bob
```

[Jump to Home](../README.md) | [Previous Training](../24_drain/README.md) | [Next Training](../26_authorization/README.md)