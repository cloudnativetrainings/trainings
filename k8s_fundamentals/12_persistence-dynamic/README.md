# Persistence with StorageClass

In the training, we will learn about Dynamic Persistence.

>Navigate to the folder `12_persistence-dynamic` from CLI, before you get started. 

## Inspect storageclass-v1.yaml definition file and create the storageclass

```bash
cat storageclass-v1.yaml
kubectl create -f storageclass-v1.yaml
```

## Show the available storage classes

>Possibly there are standard ones.
```bash
kubectl get sc -o wide
```

## Inspect pvc.yaml definition file and create the pvc

```bash
cat pvc.yaml
kubectl create -f pvc.yaml
```

## Verify that a pv got created and its state.

```bash
kubectl get pvc,pv
```

## Delete the pvc

```bash
kubectl delete pvc my-pvc
```

## Note that besides the pvc also the pv got deleted due to the `reclaimPolicy` of the storageclass

```bash
kubectl get pvc,pv
```

## Inspect storageclass-v2.yaml definition file and re-create the storageclass

```bash
cat storageclass-v2.yaml
kubectl replace -f storageclass-v2.yaml --force
```

## Inspect pvc.yaml definition file and re-create the pvc

```bash
cat pvc.yaml
kubectl create -f pvc.yaml
```

## Verify that a pv got created and its state.

```bash
kubectl get pvc,pv
```

## Delete the pvc

```bash
kubectl delete pvc my-pvc
```

## Note that pv still exists due to the `reclaimPolicy` of the storageclass

```bash
kubectl get pvc,pv
```

## Cleanup

```bash
kubectl delete pv --all
kubectl delete sc my-storageclass
```

[Jump to Home](../README.md) | [Previous Training](../11_persistence-static/README.md) | [Next Training](../13_persistence-use-volume/README.md)