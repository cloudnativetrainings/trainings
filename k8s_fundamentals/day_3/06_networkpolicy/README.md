# Network Policy

In this course we will firewall pod to pod Communication. Note that your cluster has to support Network Policies.

## Create the resources for Bob and Susan

```bash
kubectl create -f bob.yaml
kubectl create -f susan.yaml
```

## Verify that Susan can reach Bob

```bash
# Curl bob from the susan
kubectl exec -it susan -- curl bob
```

## Deny all ingress traffic

```bash
kubectl create -f networkpolicy-deny-all.yaml

# Curl bob from the susan
kubectl exec -it susan -- curl bob
```

Now Bob is not reachable from Susan.

## Create a specific rule to allow Susan access to Bob again

```bash
kubectl create -f networkpolicy-allow-susan.yaml

# Curl bob from the susan
kubectl exec -it susan -- curl bob
```

Now Bob is not reachable from Susan.

## Cleanup

```bash
kubectl delete -f .
```
