# Persistence without StorageClass

## Inspect and create the pv

```bash
kubectl create -f pv.yaml
```

## Inspect and create the pvc

```bash
kubectl create -f pvc.yaml
```

There are some issues with this structure. Try to fix these erros and verify via `kubectl get pv,pvc`. You are finished when yhour pvc is in state `Bound`

```bash
kubectl get pv,pvc
```

## Cleanup

```bash
kubectl delete pvc my-pvc
kubectl delete pv my-pv
```