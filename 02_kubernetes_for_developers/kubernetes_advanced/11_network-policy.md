# Network Policy
In this course we will firewall Pod to Pod Communication. Note that your cluster has to support Network Policies.

1. Run a Pod containing nginx and expose the Pod
```bash
kubectl run --generator run-pod/v1 bob --image nginx --port 80 --labels app=bob
kubectl expose pod bob
```
2. Create another Pod, install curl and make a request to the first pod
```bash
# run a Pod
kubectl run --generator run-pod/v1 alice --rm -it --image debian -- bash
# install curl
apt update && apt install curl -y
# curl the first Pod
curl bob
```
3. Open a new Terminal and apply the following network policy.
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
```bash
kubectl create -f my-network-policy.yaml
```
4. Switch back to the first Terminal and try to curl the first Pod again. You should not get any response due to the Network Policy
```bash
curl bob
```
