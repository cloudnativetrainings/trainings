# Secret

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

## Cleanup

```bash
kubectl delete pod my-pod
kubectl delete secret my-secret
```
