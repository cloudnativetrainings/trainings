# Deployment of the Redis Master

## 1. Deploy the Redis Master

The manifest file for the Redis Master deployment is located at [./guestbook/redis-master-deployment.yaml](./guestbook/redis-master-deployment.yaml). The configured number of replicas is only one. Labels help to select the deployment and the pod by different perspectives. They are

* the application (`redis`),
* its special role (`master`),
* and the tier inside the whole system (`backend`).

Requested resources are also be limited to not starve other processes.

Now copy or upload the manifest file and apply it to your cluster.

```sh
kubectl apply -f redis-master-deployment.yaml
```

Why don't you need to add the namespece to the command?

Now check if Redis is running. Query the list of pods.

```sh
kubectl get pods
```

Why don't you see Redis? Try it again with the namespace.

```sh
kubectl get pods -n guestbook
```

The output should be similar to

```sh
NAME                          READY   STATUS    RESTARTS   AGE
redis-master-7db99fb5-xsgjp   1/1     Running   0          11s
```

Now check the log of the Redis Master pod. Replace the name of the Pod with the name of your pod listened above.

```sh
kubectl logs -n guestbook -f redis-master-7db99fb5-xsgjp
```

You should see the starting log of Redis. Cancel following the logging by pressing `<Ctrl-C>`.

## 2. Create the Redis Master Service

While the deployment is running we need to let the guestbook communicate to it. So we need to create an according service. You'll find the file at [./guestbook/redis-master-service.yaml](./guestbook/redis-master-service.yaml).

The file contains a selector matching to the labels of the the deployment to let it address the pod correctly. It defines the policy to access the pod by defining port and target port.

Copy or upload this file too and apply it to your cluster.

```sh
kubectl apply -f redis-master-service.yaml
```

Check if the service is running.

```sh
kubectl get services -n guestbook
```

The output shoud be similar to

```sh
NAME           TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
redis-master   ClusterIP   10.48.13.16   <none>        6379/TCP   2m5s
```

Now the Redis Master is up and running.

[TOP](./) / [NEXT >>](./02_deploy_redis_slaves.md)
