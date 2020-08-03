# Add Redis volume

So far the Redis Master uses the container internal directory `/data` for persistency. This way all data would get lost when the container dies. So we now want to mount a persistent volume claim to this directory.

## 1. Create the storage class

First step is defining a storage class to be used by the claim. The according file is [./guestbook/redis-master-storageclass.yaml](./guestbook/redis-master-storageclass.yaml). The example is configured for the Google Cloud Platform, so make sure that the zone is correct. Storage classes are one of the global objects. So the file contains no namespace.

Apply the file to your cluster.

```sh
kubectl apply -f redis-master-storageclass.yaml
```

Now check if it has been created. Specifying a namespace is not needed.

```sh
kubectl get sc
```

You should get an output similar to this.

```sh
NAME                 PROVISIONER            AGE
redis                kubernetes.io/gce-pd   6h15m
standard (default)   kubernetes.io/gce-pd   6h31m
```

## 2. Claim a volume based on the storage class

Now a persistent volume claim to be used by the Redis Master deployment can be created. The according file can be found at [./guestbook/redis-master-pvc.yaml](./guestbook/redis-master-pvc.yaml). The name already tells that it is the PVC for the Redis Master and it will be in namespace `redis`. The spec tells, that the storage class `redis` shall be used, the access mode allows only one pod to write. This is okay as only the one Redis Master pod will use it.

Apply the file to your cluster.

```sh
kubectl apply -f redis-master-pvc.yaml
```

Now check if volume and claim have been created.

```sh
kubectl get pv,pvc -n guestbook
```

You should get an output similar to this.

```sh
NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM          STORAGECLASS   REASON   AGE
persistentvolume/pvc-5266e840-0279-4369-9b61-52b6c256034c   10Gi       RWO            Delete           Bound    guestbook/pvc-redis-master   redis                   6h23m
NAME                                     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pvc-redis-master   Bound    pvc-5266e840-0279-4369-9b61-52b6c256034c   10Gi       RWO            redis   6h23m
```

## 3. Use the volume in the Redis Master

To use the volume in the Redis Master and mount it to the directory `/data` the according deployment file has to be changed. The example contains an extended file at [./guestbook/redis-master-deployment-volume.yaml](./guestbook/redis-master-deployment-volume.yaml). It contains the volume section referencing the persistent volume claim `pvc-redis-master`, its name is the same. And it is used in the volume mounts section inside the Redis container, mountpoint is `/data`.

Now apply the new Redis Master deployment. But first the current one has to be deleted. When the new one starts you can see how the slaves reconnect and sync inside the new master log.

```sh
kubectl delete deployment redis-master -n guestbook
kubectl apply -f redis-master-deployment-volume.yaml
```

To check you now can execute a shell inside the master container.

```sh
kubectl exec -n guestbook -it redis-master-5df7875d5d-qtp6f -- bash
```

Here a `ll /data` shows the typical `lost+found` directory of a mounted filesystem and a `cat /etc/mtab | grep data` shows the mounted *drive* and the mountpoint.

[<< PREV](././04_scale_guestbook.md) / [TOP](./)
