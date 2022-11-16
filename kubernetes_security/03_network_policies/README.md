# Network Policies

In this training course, we will firewall pod to pod Communication. Note that your cluster has to support Network Policies.

## Create the resources for frontend and backend

```bash
kubectl create -f /root/03_network_policies/frontend.yaml
kubectl create -f /root/03_network_policies/backend.yaml
```

## Verify that frontend can reach backend

Curl backend from the frontend
```bash
kubectl exec -it frontend -- curl backend
```

## Deny all ingress and egress traffic

```bash
kubectl create -f /root/03_network_policies/networkpolicy-deny-all.yaml
```

Curl backend from the frontend
```bash
kubectl exec -it frontend -- curl --connect-timeout 5 backend
```

>Now backend is not reachable from frontend due to Name Resolution timeout failure.

## Allow for DNS traffic

```bash
kubectl create -f /root/03_network_policies/networkpolicy-allow-dns.yaml
```

Curl backend from the frontend
```bash
kubectl exec -it frontend -- curl --connect-timeout 5 backend
```
>Backend is not reachable due to Connection Timeout

## Create a specific rules to allow frontend access to backend again

```bash
kubectl create -f /root/03_network_policies/networkpolicy-allow-be-ingress.yaml
```

Curl backend from the frontend
```bash
kubectl exec -it frontend -- curl --connect-timeout 5 backend
```
>Backend is still not reachable from frontend (egress is still not allowed).

```bash
kubectl create -f /root/03_network_policies/networkpolicy-allow-fe-egress.yaml
```

Curl backend from the frontend
```bash
kubectl exec -it frontend -- curl backend
```
>Finally, firewall between frontend and backend is open, and it works!

## Cleanup

```bash
kubectl delete -f /root/03_network_policies/
```
