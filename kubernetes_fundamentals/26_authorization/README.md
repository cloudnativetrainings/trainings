# Authorization

In the training, we will learn about create role based access for a user to grant access on specific k8s cluster resources.

>Navigate to the folder `26_authorization` from CLI, before you get started. 

## Inspect definition files and create the servicaccount, clusterrole and clusterrolebinding

```bash
cat serviceaccount.yaml
cat clusterrole.yaml
cat clusterrolebinding.yaml
```

```bash
kubectl create -f serviceaccount.yaml
kubectl create -f clusterrole.yaml
kubectl create -f clusterrolebinding.yaml
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

## Cleanup

```bash
kubectl delete -f .
```

[Jump to Home](../README.md) | [Previous Training](../25_authentication/README.md) | [Next Training](../27_networkpolicies/README.md)