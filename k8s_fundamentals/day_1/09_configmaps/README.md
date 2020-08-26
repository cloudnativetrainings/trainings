# ConfigMap

Note that there are errors in the yaml files. Try to fix them.

## Inspect the [configmap yaml file](./configmap.yaml) and create the configmap

```bash
kubectl create -f configmap.yaml
```

## Inspect the [pod yaml file](./pod.yaml) and create the pod

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
