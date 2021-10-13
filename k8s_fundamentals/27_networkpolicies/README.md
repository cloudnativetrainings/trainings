# Network Policies

In this training course, we will firewall pod to pod Communication. Note that your cluster has to support Network Policies.

>Navigate to the folder `27_networkpolicies` from CLI, before you get started. 

## Create the resources for Bob and Susan

```bash
kubectl create -f bob.yaml
kubectl create -f susan.yaml
```

## Verify that Susan can reach Bob

Curl bob from the susan
```bash
kubectl exec -it susan -- curl bob
```

## Deny all ingress traffic

```bash
kubectl create -f networkpolicy-deny-all.yaml
```

Curl bob from the susan
```bash
kubectl exec -it susan -- curl bob
```
>Now Bob is not reachable from Susan.

## Create a specific rule to allow Susan access to Bob again

```bash
kubectl create -f networkpolicy-allow-susan.yaml
```

Curl bob from the susan
```bash
kubectl exec -it susan -- curl bob
```
>Now Bob is not reachable from Susan.

## Cleanup

```bash
kubectl delete -f .
```

[Jump to Home](../README.md) | [Previous Training](../26_authorization/README.md) | [Next Training](../28_helm/README.md)