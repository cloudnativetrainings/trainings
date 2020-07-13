# Deployment of the Redis Slaves

## 1. Deploy the Redis Slaves

The manifest file for the slave can be found at [./guestbook/redis-slave-deployment.yam](./guestbook/redis-slave-deployment.yaml). It's quite similar to the Redis Master deployment, two replicas are configured.

Copy or upload the manifest file and apply it to your cluster.

```sh
kubectl apply -f redis-slave-deployment.yaml
```

Now check if the slaves are running. Query the list of pods.

```sh
kubectl get pods -n guestbook
```

The output should be similar to

```sh
NAME                           READY   STATUS    RESTARTS   AGE
redis-master-7db99fb5-xsgjp    1/1     Running   0          166m
redis-slave-5955c6dc66-bxfkg   1/1     Running   0          97s
redis-slave-5955c6dc66-hq6fg   1/1     Running   0          97s
```

## 2. Create the Redis Slave service

Like the Redis Master the Slaves need a service too. It allows the guestbook frontends to read the data. The according file can be found at [./guestbook/redis-slave-service.yaml](./guestbook/redis-slave-service.yaml). Upload or copy and apply it to your cluster.

```sh
kubectl apply -f redis-slave-service.yaml
```

Check the started services again with

```sh
kubectl get svc -n guestbook
```

The output should be similar to

```sh
NAME           TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
redis-master   ClusterIP   10.48.13.16   <none>        6379/TCP   120m
redis-slave    ClusterIP   10.48.2.144   <none>        6379/TCP   4s
```

So now you've got a three node Redis database with one master and two slaves. Now let's continue with the guestbook.

[<< PREV](./01_deploy_redis_master.md) / [TOP](./README.md) / [NEXT >>](./03_deploy_guestbook.md)
