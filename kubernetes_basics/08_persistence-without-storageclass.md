# Persistence without StorageClass

1. Create a PV and a PVC. 
```yaml 
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-selector-example
  labels:
    type: host-pv
spec:
  #overwrite the to use NO storage class
  storageClassName: ""
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    type: DirectoryOrCreate
    path: "/tmp/mypvselector"
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-selector-example
spec:
  #overwrite the to use NO storage class
  storageClassName: ""
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi
  selector:
    matchLabels:
      type: hostpath
```
2. There are some issues with this structure. Try to fix these erros and verify via `kubectl get pv,pvc`. You are finished if you get a similar output like this:
```bash
kubectl get pv,pvc
NAME                                   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                          STORAGECLASS   REASON   AGE
persistentvolume/pv-selector-example   2Gi        RWX            Retain           Bound    default/pvc-selector-example                           4s

NAME                                         STATUS   VOLUME                CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pvc-selector-example   Bound    pv-selector-example   2Gi        RWX                           4s
```