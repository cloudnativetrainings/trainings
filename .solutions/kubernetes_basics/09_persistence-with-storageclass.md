## Solution

- Storage class names need to match

One potential solution:

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
  storageClassName: "local-storage"
  resources:
    requests:
      storage: 1Gi
```