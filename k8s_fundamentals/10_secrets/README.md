# Secrets

In the training, we will learn about Secrets.

>Navigate to the folder `10_secrets` from CLI, before you get started. 

>Note that, there are errors in the yaml files. Try to fix them.

## Inspect secret.yaml definition file and create the secret

```bash
cat secret.yaml
kubectl create -f secret.yaml
```

## Inspect pod.yaml definition file and create the pod

```bash
cat pod.yaml
kubectl create -f pod.yaml
```

## Verify everything works fine

```bash
kubectl exec -it my-pod -- cat /opt/my-volume/<FILENAME>
```

## Output the secret value

```bash
kubectl get secret my-secret -o yaml
```

Convert the secret into human readable format
```bash
kubectl get secret my-secret -o jsonpath='{.data.foo}' | base64 -d
```

## Cleanup

```bash
kubectl delete pod my-pod
kubectl delete secret my-secret
```

[Jump to Home](../README.md) | [Previous Training](../09_configmaps/README.md) | [Next Training](../11_persistence-static/README.md)