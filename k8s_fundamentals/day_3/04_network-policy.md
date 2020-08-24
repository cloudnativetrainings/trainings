# Network Policy

In this course we will firewall Pod to Pod Communication. Note that your cluster has to support Network Policies.

## 1. Run a Pod containing nginx and expose the Pod

```bash
## Create a Deployment
kubectl create deployment bob --image nginx --labels app=bob

## Expose the Deployment
kubectl expose deployment bob --port 80
```

## 2. Create another Pod, install curl and make a request to the first Pod

```bash
## Run a Pod
kubectl run --generator run-pod/v1 alice --rm -it --image debian -- bash

## Install curl
apt update && apt install curl -y

## Curl the first Pod
curl bob
```

## 3. Open a new terminal and apply the following network policy

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: my-network-policy
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

Apply it to your cluster.

```bash
kubectl create -f my-network-policy.yaml
```

## 4. Switch back to the first terminal and try to curl the first Pod again

You should not get any response due to the Network Policy.

```bash
curl bob
```
