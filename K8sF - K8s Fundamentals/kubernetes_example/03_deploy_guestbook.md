# Deployment of the Guestbook Frontend

## 1. Deploy the Guestbook Frontend

The manifest file for the guestbook frontend can be found at [./guestbook/frontend-deployment.yaml](./guestbook/frontend-deployment.yaml). It will run the PHP Redis Guestbook on three nodes. Copy and upload the file and apply it.

```sh
kubectl apply -f frontend-deployment.yaml
```

Check that these pods are running.

```sh
kubectl get pods -n guestbook -l app=guestbook -l tier=frontend
```

By specifying the labels we don't get all pods but those of the frontend. The output should look like this.

```sh
NAME                        READY   STATUS    RESTARTS   AGE
frontend-86d587b77b-cbmbr   1/1     Running   0          4m41s
frontend-86d587b77b-hhxp8   1/1     Running   0          4m41s
frontend-86d587b77b-v4gvt   1/1     Running   0          4m41s
```

## 2. Create the Guestbook Frontend service

So far the Redis Master and Slaves are only intended to communicate inside the cluster. So using the `ClusterIP` is enough. The Guestbook Frontend instead shall be reachable from outside. So we'll create a `LoadBalancer` service here.

The according file can be found at [./guestbook/frontend-service.yaml](./guestbook/frontend-service.yaml). Upload or copy it again and apply it to your cluster.

```sh
kubectl apply -f frontend-service.yaml
```

Check your services by calling

```sh
kubectl get svc -n guestbook
```

The output should be similar to

```sh
NAME           TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)        AGE
frontend       LoadBalancer   10.48.13.245   35.242.219.5   80:32581/TCP   3m20s
redis-master   ClusterIP      10.48.13.16    <none>         6379/TCP       158m
redis-slave    ClusterIP      10.48.2.144    <none>         6379/TCP       37m
```

Now the guestbook can be reached via the browser using the external IP address.

[<< PREV](./02_deploy_redis_slaves.md) / [TOP](./) / [NEXT >>](./04_scale_guestbook.md)
