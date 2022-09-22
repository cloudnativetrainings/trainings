# Deploy a simple application

Please follow this guide to verify that the Kubernetes cluster is running as expected.

In this scenario, we will deploy a simple application to our existing Kubernetes cluster using a Kubernetes object called `Deployment`.

If you have already a deeper experience with Kubernetes, you can verify the cluster by your own and potentially skip this chapter.

## Create a namespace

* For easy cleanup, first create a new namespace:
  ```bash
  kubectl create ns app
  ```

* Change your context to use that namespace:
  ```bash
  kubectl config set-context --current --namespace=app
  ```
  or with kcns
  ```bash
  kcns app
  ```

## Create a deployment

* In this step, we will create a new deployment using `nginx` web server image with below command.
  ```bash
  kubectl create deployment nginx --image=nginx
  ```

* Verify deployment using below command.
  ```bash
  kubectl get deployments
  ```
  Output:
  ```text
  NAME    READY   UP-TO-DATE   AVAILABLE   AGE
  nginx   1/1     1            1           20s
  ```

* View the details of deployment

  Use below command to retrieve the details of our newly created deployment. It shows details like name, namespace, selectors and many others.
  ```bash
  kubectl describe deployment nginx
  ```

## View the YAML

When we ask Kubernetes to create a deployment, it performs few steps to achieve same. We can view those steps using the command -
```bash
kubectl get events
```

We can also get the yaml from an existing deployment using the command - 
```bash
kubectl get deployment nginx -o yaml | kexp
```

## Reuse the YAML

Save the output yaml to a file using 
```bash
kubectl get deployment nginx -o yaml | kexp > first.yaml
```

Open a file using `vim first.yaml`:

Now the yaml file should look similar to this example:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx
  namespace: app
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: nginx
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: nginx
        resources: 
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: 
      terminationGracePeriodSeconds: 30
```

Now delete the existing deployment using the command 
```bash
kubectl delete deployment nginx
```

Create a new deployment from the file we just modified, using 
```bash
kubectl apply -f first.yaml
```
> We can now use the `first.yaml` to check if the cluster behaves like expected. 

> **HINT:** `kubectl get <OBJECT> -o yaml | kexp` removes `status` and `metadata` fields for you. `kexp` is a command of [fubectl](https://github.com/kubermatic/fubectl).

## Expose deployment using a service

The newly deployed nginx container is a lightweight web server. We will need to create a service to view the default welcome page over a stable IP of a Kubernetes object called `Service`.

Now to expose a deployment, we need to execute 
```bash
kubectl expose deployment/nginx
```

As we have not declared port to use we will get following error.

```text
error: couldn't find port via --port flag or introspection
See 'kubectl expose -h' for help and examples.
```

This is because we haven't added port for container to listen on. To do this open `first.yaml` in a `vim` using `vim first.yaml`.

Find the container name in a file and add the port information as mentioned below.

```yaml
spec:
    containers:
    - image: nginx
        imagePullPolicy: Always
        name: nginx
        ports:                               # Add these
        - containerPort: 80                  # three
          protocol: TCP                      # lines
        resources: 
```

Save the file and apply the change by using 
```bash
kubectl apply -f first.yaml
```

View the Pod and Deployment using 
```bash
kubectl get deploy,pod
```
> Note the AGE shows that the pod was re-created.


Try to expose a resource again using 
```bash
kubectl expose deployment/nginx
```

Verify the service configuration using `
```bash
kubectl get svc,ep nginx
```
It should show an output similar to the one given below.
```text
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/nginx   ClusterIP   10.110.86.101   <none>        80/TCP    58s

NAME              ENDPOINTS       AGE
endpoints/nginx   10.244.3.4:80   58s
```

Our nginx server is now reachable through the service IP and the endpoint IP. We can test access to the Cluster IP by using a troubleshooting container to trigger a request from the inside of the cluster:

```bash
kubectl run --image=nicolaka/netshoot --rm -it -- bash
curl http://<cluster-ip>
curl http://<endpoint-ip>
exit
```

## Scale up the deployment 

In this step we will scale deployment up to three replicas. Use following command to check existing deployment.
```bash
kubectl get deployment nginx
```

You can output similar to following.

```text
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   1/1     1            1           12
```
>It shows that the deployment created a one replica, and it is ready to serve.

Now we want to scale our deployment to have 3 replicas. It can be done using command 
```bash
kubectl scale deployment nginx --replicas=3
```
>It will show message `deployment.apps/nginx scaled` indicating that scaling done successfully.

We can re-check the scaled deployment using 
```bash
kubectl get deployment,service,endpoints nginx
```

You can see output similar to the following.

```text
NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   3/3     3            3           6m30s

NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/nginx   ClusterIP   10.110.86.101   <none>        80/TCP    5m43s

NAME              ENDPOINTS                                   AGE
endpoints/nginx   10.244.3.4:80,10.244.3.5:80,10.244.4.6:80   5m43s
```
>Notice the number `3` in the output in various columns. It shows that our deployment is scaled to 3 replicas successfully and all of them are ready to serve traffic.

## Cleanup the App namespace

After we tested the app deployment, we can delete the namespace to clean-up:

```bash
kubectl delete ns app
```

Jump > [**Home**](../README.md) | Previous > [**First KubeOne Cluster Setup**](../03_first-kubeone-cluster/README.md) | Next > [**HA Cluster Setup**](../05_HA-master/README.md)