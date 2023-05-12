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
kubectl get deployment nginx -o yaml 
```

## Reuse the YAML

Save the output yaml to a file using 
```bash
kubectl get deployment nginx -o yaml > first.yaml
```

## Expose deployment using a service

The newly deployed nginx container is a lightweight web server. We will need to create a service to view the default welcome page over a stable IP of a Kubernetes object called `Service`.

Now to expose a deployment, we need to execute 
```bash
kubectl expose deployment/nginx --port 80
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
curl nginx
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