# Persistence with StorageClass

## Inspect the [storageclass yaml file](./storageclass-v1.yaml) and create the storageclass

```bash
kubectl create -f storageclass-v1.yaml
```

## Show the available storage classes

Possibly there are standard ones.

```bash
kubectl get sc -o wide
```

## Inspect the [pvc yaml file](./pvc.yaml) and create the pvc

```bash
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

## Inspect the [storageclass yaml file](./storageclass-v2.yaml) and re-create the storageclass

```bash
kubectl replace -f storageclass-v2.yaml --force
```

## Inspect the [pvc yaml file](./pvc.yaml) and re-create the pvc

```bash
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