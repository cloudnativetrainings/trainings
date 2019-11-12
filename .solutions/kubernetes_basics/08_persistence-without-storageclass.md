## Solution

- Label `type` need to be equal
- Requested storage size `10Gi` is to big for the persistent volume size `2Gi`

One potential solution could look like:

```yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-selector-example
  labels:
    type: hostpath
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
      storage: 1Gi
  selector:
    matchLabels:
      type: hostpath
```