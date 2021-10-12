# ConfigMaps

In the training, we will learn about Configmaps.

>Navigate to the folder `09_configmaps` from CLI, before you get started. 

>Note that, there are errors in the yaml files. Try to fix them.

## Inspect configmap.yaml definition file and create the configmap

```bash
cat configmap.yaml
kubectl create -f configmap.yaml
```

## Inspect pod.yaml definition file and create the pod

```bash
cat pod.yaml
kubectl create -f pod.yaml
```

## Verify everything works fine

```bash
kubectl logs my-pod
```
Output: 
```
bar
```

## Cleanup

```bash
kubectl delete po,cm --all
```

[Jump to Home](../README.md) | [Previous Training](../08_services/README.md) | [Next Training](../10_secrets/README.md)