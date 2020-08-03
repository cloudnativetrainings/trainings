# Scale the Gustebook Frontend up and down

## 1. Manually scale up and down

The servers for the Guestbook are defined as service that uses a deployment controller. This way manually scaling up and down is quite simple.

To scale the Guestbook Frontend up to five pods enter

```sh
kubectl scale deployment frontend --replicas=5 -n guestbook
```

Now when running

```sh
kubectl get pods -n guestbook
```

you should get an output similar to

```sh
NAME                           READY   STATUS    RESTARTS   AGE
frontend-86d587b77b-cbmbr      1/1     Running   0          52m
frontend-86d587b77b-hhxp8      1/1     Running   0          52m
frontend-86d587b77b-kqp9c      1/1     Running   0          27s
frontend-86d587b77b-q4d6n      1/1     Running   0          27s
frontend-86d587b77b-v4gvt      1/1     Running   0          52m
redis-master-7db99fb5-xsgjp    1/1     Running   0          4h8m
redis-slave-5955c6dc66-bxfkg   1/1     Running   0          83m
redis-slave-5955c6dc66-hq6fg   1/1     Running   0          83m
```

The same way the command

```sh
kubectl scale deployment frontend --replicas=2 -n guestbook
```

will scale the number of Guestbook Frontends down to two. After a few seconds of termination the command

```sh
kubectl get pods -n guestbook
```

will output a status similar to

```sh
NAME                           READY   STATUS    RESTARTS   AGE
frontend-86d587b77b-cbmbr      1/1     Running   0          64m
frontend-86d587b77b-hhxp8      1/1     Running   0          64m
redis-master-7db99fb5-xsgjp    1/1     Running   0          4h21m
redis-slave-5955c6dc66-bxfkg   1/1     Running   0          96m
redis-slave-5955c6dc66-hq6fg   1/1     Running   0          96m
```

## 2. Automatically scale up and down

Scaling can also be done automatically based on the load. It will be done with a horizontal pod autoscaler based you can find in the file [./guestbook/frontend-autoscaler.yaml](./guestbook/frontend-autoscaler.yaml). After uploading or copying it your can apply it with the command

```sh
kubectl apply -f frontend-autoscaler.yaml
```

Initially checking the pods will show the same number. Now open a second terminal and produce some load.

```sh
while true; do wget -q -O- http://35.242.219.5/; done
```

Now you can check how the number of parallel frontend pods raises to five. When load is over the number of pods will scale down after some time. A manual downscaling is also possible.

[<< PREV](./03_deploy_guestbook.md) / [TOP](./) / [NEXT >>](./05_add_redis_volume.md)
