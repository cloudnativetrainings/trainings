# Manage Secrets with Vault

In this task, we will use HashiCorp Vault to store and use our `Secrets` securely.

Change into the lab directory:

```bash
cd $HOME/trainings/kubernetes_fundamentals_for_developers/10_secrets
```

## Configure Vault

Vault CLI is already installed on the Google Cloud Shell and the Helm Chart is already applied in your cluster. However, the vault-0 pod will not become ready automatically.

### Unseal Vault in the Cluster

```bash
kubectl get pods -n vault
NAME                                    READY   STATUS    RESTARTS   AGE
vault-0                                 0/1     Running   0          25s
vault-agent-injector-55748c487f-xflrn   1/1     Running   0          25s
```

The vault is `sealed`. You can check the application status:

```bash
kubectl exec -it vault-0 -n vault -- vault status

# output
# Key                Value
# ---                -----
# Seal Type          shamir
# Initialized        false
# Sealed             true
# Total Shares       0
# Threshold          0
# Unseal Progress    0/0
# Unseal Nonce       n/a
# Version            1.15.2
# Build Date         2023-11-06T11:33:28Z
# Storage Type       file
# HA Enabled         false
# command terminated with exit code 2
```

Now, exec into the vault container, run init and unseal it (you need to use 3 keys to unseal)

```bash
kubectl exec -it vault-0 -n vault -- /bin/sh
/ $ vault operator init
# Unseal Key 1: xxx_token_1
# Unseal Key 2: xxx_token_2
# Unseal Key 3: xxx_token_3
# Unseal Key 4: xxx_token_4
# Unseal Key 5: xxx_token_5
#
# Initial Root Token: xxx_root_token
#
# Vault initialized with 5 key shares and a key threshold of 3. Please securely
# distribute the key shares printed above. When the Vault is re-sealed,
# restarted, or stopped, you must supply at least 3 of these keys to unseal it
# before it can start servicing requests.
#
# Vault does not store the generated root key. Without at least 3 keys to
# reconstruct the root key, Vault will remain permanently sealed!
#
# It is possible to generate new unseal keys, provided you have a quorum of
# existing unseal keys shares. See "vault operator rekey" for more information.
/ $
/ $ vault operator unseal xxx_token_1
# Key                Value
# ---                -----
# Seal Type          shamir
# Initialized        true
# Sealed             true
# Total Shares       5
# Threshold          3
# Unseal Progress    1/3
# Unseal Nonce       f46a09cd-d398-90a4-f039-90ae812f3595
# Version            1.15.2
# Build Date         2023-11-06T11:33:28Z
# Storage Type       file
# HA Enabled         false
/ $
/ $ vault operator unseal xxx_token_2
# Key                Value
# ---                -----
# Seal Type          shamir
# Initialized        true
# Sealed             true
# Total Shares       5
# Threshold          3
# Unseal Progress    2/3
# Unseal Nonce       f46a09cd-d398-90a4-f039-90ae812f3595
# Version            1.15.2
# Build Date         2023-11-06T11:33:28Z
# Storage Type       file
# HA Enabled         false
/ $
/ $ vault operator unseal xxx_token_3
# Key             Value
# ---             -----
# Seal Type       shamir
# Initialized     true
# Sealed          false
# Total Shares    5
# Threshold       3
# Version         1.15.2
# Build Date      2023-11-06T11:33:28Z
# Storage Type    file
# Cluster Name    vault-cluster-0a1fba5b
# Cluster ID      cf4936a1-eb13-6998-e3ec-c5194dbc374d
# HA Enabled      false
/ $ exit
```

Now, verify that `vault-0` pod is also running:

```bash
kubectl get pods -n vault
NAME                                    READY   STATUS    RESTARTS   AGE
vault-0                                 1/1     Running   0          116m
vault-agent-injector-55748c487f-xflrn   1/1     Running   0          116m
```

### Prepare vault to be used with our Pods inside Kubernetes

```bash
kubectl exec -it vault-0 -n vault -- /bin/sh
# Login to the vault
/ $ vault login xxx_root_token  # <-- this is the root token from init command

# Create a Key-value store called myapp
/ $ vault secrets enable -path=myapp kv-v2

# Create a secret called secret-data with username, password, and apikey
/ $ vault kv put myapp/secret-data username=admin password=DScq53H9gGKkepCs

# Create a read policy
/ $ cat <<EOF > /home/vault/policy.hcl
path "myapp/data/secret-data" {
  capabilities = ["read"]
}
EOF

# Apply the policy
/ $ vault policy write myapp-policy /home/vault/policy.hcl

# Enable Kubernetes authentication
/ $ vault auth enable kubernetes

# Configure Kubernetes auth
/ $ vault write auth/kubernetes/config \
  token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"  \
  kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# Create the role with our policy on the default namespace
/ $ vault write auth/kubernetes/role/vault-read \
  bound_service_account_names=default \
  bound_service_account_namespaces=default \
  policies=myapp-policy \
  ttl=24h

# Exit the vault-0 container
/ $ exit
```

## Deploy a Pod with Secrets from Vault

Check the pod spec:

> [!TIP]
> Pay attention to `metadata.annotations` field.

```bash
cat k8s/pod.yaml
```

Apply the manifests and see it working:

```bash
kubectl create -f k8s/
```

Checkout the created `db-creds` file:

```bash
kubectl exec -it my-app -c my-app -- cat /vault/secrets/db-creds
```

## Cleanup

Remove installed applications and pods

```bash
kubectl delete -f k8s/
```
