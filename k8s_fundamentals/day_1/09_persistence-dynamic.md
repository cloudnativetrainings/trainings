# Persistence with StorageClass

## 1. Create the file persistence.yaml with a storage class and two claims

Take care that the zone of your StorageClass matches the zone of your Kubernetes Cluster. You can get the zone of your nodes via:
```bash
kubectl describe node | grep zone
```

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: myStorageclass
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-standard
  zones: europe-west3-a
reclaimPolicy: Delete
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-30-myStorageclass
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: myStorageclass
  resources:
    requests:
      storage: 30Gi
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-10-myStorageclass
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: myStorageclass
  resources:
    requests:
      storage: 10Gi
```

```bash
kubectl create -f persistence.yaml
```

## 2. Get information about PersistentVolumes and PersistentVolumeClaims

Run `kubectl get pv,pvc`. Take a look at the number and the names of the volumes.

```bash
$ kubectl get pv,pvc
NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                STORAGECLASS   REASON   AGE
persistentvolume/pvc-719e1838-16f3-11ea-9419-42010a8e0162   30Gi       RWO            Delete           Bound    default/pvc-30-myStorageclass   myStorageclass                    22m
persistentvolume/pvc-9f8b0df2-16f3-11ea-9419-42010a8e0162   10Gi       RWO            Delete           Bound    default/pvc-10-myStorageclass   myStorageclass                    20m
NAME                                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pvc-10-myStorageclass   Bound    pvc-9f8b0df2-16f3-11ea-9419-42010a8e0162   10Gi       RWO            myStorageclass           20m
persistentvolumeclaim/pvc-30-myStorageclass   Bound    pvc-719e1838-16f3-11ea-9419-42010a8e0162   30Gi       RWO            myStorageclass           22m
```

## 3. Show the available storage classes

Possibly there are standard ones.

```bash
## show available storage classes
kubectl get sc -o wide
```

## 4. Delete the PVCs

```bash
kubectl delete pvc --all
```

Note that besides the PVCs also the PVs got deleted due to the `reclaimPolicy` of the StorageClass.

```bash
kubectl get pvc,pv
```
