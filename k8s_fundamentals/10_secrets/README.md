# Secrets

Note that there are errors in the yaml files. Try to fix them.

## Inspect and create the secret

```bash
kubectl create -f secret.yaml
```

## Inspect and create the pod

```bash
kubectl create -f pod.yaml
```

## Verify everything works fine

```bash
kubectl exec -it my-pod -- cat /opt/my-volume/<FILENAME>
```

## Output the secret value

```bash
kubectl get secret my-secret -o yaml

# Convert the secret into human readable format
kubectl get secret my-secret -o jsonpath='{.data.foo}' | base64 -d
```

## Cleanup

```bash
kubectl delete pod my-pod
kubectl delete secret my-secret
```

[Jump to Home](../README.md) | [Previous Training](../09_configmaps/README.md) | [Next Training](../11_persistence-static/README.md)