# Network Policies

In this training course, we will firewall pod to pod Communication. Note that your cluster has to support Network Policies.

## Create the resources for frontend and backend

```bash
kubectl create -f 03_network_policies/frontend.yaml
kubectl create -f 03_network_policies/backend.yaml
```

## Verify that frontend can reach backend

```bash
# curl backend from the frontend => this should work
kubectl exec -it frontend -- curl backend
```

## Deny all ingress and egress traffic

```bash
# apply deny all network policy
kubectl create -f 03_network_policies/networkpolicy-deny-all.yaml

# curl backend from the frontend  => backend is not reachable from frontend due to name resolution timeout failure
kubectl exec -it frontend -- curl --connect-timeout 5 backend
```

## Allow for DNS traffic

```bash
# apply the DNS network policy
kubectl create -f 03_network_policies/networkpolicy-allow-dns.yaml

# curl backend from the frontend => backend is still not reachable due to connection timeout
kubectl exec -it frontend -- curl --connect-timeout 5 backend
```

## Create a specific rules to allow frontend access to backend again

```bash
# apply the network policy to allow ingress trafic to the backend
kubectl create -f 03_network_policies/networkpolicy-allow-be-ingress.yaml

# curl backend from the frontend => backend is still not reachable from frontend due to egress is still not allowed
kubectl exec -it frontend -- curl --connect-timeout 5 backend

# apply the network policy to allow egress trafic from the frontend
kubectl create -f 03_network_policies/networkpolicy-allow-fe-egress.yaml

# curl backend from the frontend => finally, firewall between frontend and backend is open, and it works!
kubectl exec -it frontend -- curl backend
```

## Cleanup

```bash
kubectl delete -f 03_network_policies/
```
