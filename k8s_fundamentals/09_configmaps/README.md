# ConfigMaps

Note that there are errors in the yaml files. Try to fix them.

## Inspect and create the configmap

```bash
kubectl create -f configmap.yaml
```

## Inspect and create the pod

```bash
kubectl create -f pod.yaml
```

## Verify everything works fine

```bash
kubectl logs my-pod
bar
```

## Cleanup

```bash
kubectl delete po,cm --all
```

[Jump to Home](../README.md) | [Previous Training](../08_services/README.md) | [Next Training](../10_secrets/README.md)