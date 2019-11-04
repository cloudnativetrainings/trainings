# Persistence with StorageClass

1. Create a PV and a PVC. 
```yaml 
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-storage-class-example
  labels:
    type: hostpath
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  storageClassName: "local-storage"
  hostPath:
    type: DirectoryOrCreate
    path: "/tmp/mypvsc"
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-storage-class-example
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
```
2. There is an issue with this structure. Try to fix the error and verify via `kubectl get pv,pvc`. You are finished if you get a similar output like this:
```bash
kubectl get pv,pvc
NAME                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                               STORAGECLASS    REASON   AGE
persistentvolume/pv-storage-class-example   5Gi        RWX            Retain           Bound    default/pvc-storage-class-example   local-storage            5s

NAME                                              STATUS   VOLUME                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
persistentvolumeclaim/pvc-storage-class-example   Bound    pv-storage-class-example   5Gi        RWX            local-storage   5s
```