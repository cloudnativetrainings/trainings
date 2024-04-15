# Authorization

In the training, we will learn about create role based access for a user to grant access on specific k8s cluster resources.

> Note: Instead of calling the Kubernetes API from our application we simply use curl in this lab. The important point here is that programming language specific Kubernetes Libraries use exactly the mechanisms and files shown in this lab.

>Navigate to the folder `03_kubernetes_api` from CLI, before you get started.

## Inspect definition files and create the servicaccount, clusterrole and clusterrolebinding

```bash
cat k8s/serviceaccount.yaml
cat k8s/clusterrole.yaml
cat k8s/clusterrolebinding.yaml
```

```bash
kubectl create -f k8s/serviceaccount.yaml
kubectl create -f k8s/clusterrole.yaml
kubectl create -f k8s/clusterrolebinding.yaml
```

## Inspect pod.yaml definition file and create the pod

```bash
cat pod.yaml
kubectl create -f pod.yaml
```

## Exec into the container

```bash
kubectl exec -it my-pod -- /bin/sh
```

## Inspect the serviceaccount folder

```bash
cd /var/run/secrets/kubernetes.io/serviceaccount/
ls 
```

## Set the TOKEN variable

```bash
TOKEN=$(cat token)
```

## Try to access the api-server

* List the pods - this is allowed

```bash
curl -s https://kubernetes/api/v1/namespaces/default/pods/ --header "Authorization: Bearer $TOKEN" --cacert ca.crt 
```

* List the services - you should get a 403 status code back

```bash
curl -s https://kubernetes/api/v1/namespaces/default/services/ --header "Authorization: Bearer $TOKEN" --cacert ca.crt 
```

## Exit the Pod

```bash
exit
```

## Cleanup

```bash
kubectl delete -f k8s
```
