# Authorization

## Inspect and create the servicaccount, clusterrole and clusterrolebinding

```bash
kubectl create -f serviceaccount.yaml
kubectl create -f clusterrole.yaml
kubectl create -f serviceaccount.yaml
```

## Inspect and create the pod

```bash
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

```bash
# List the pods - this is allowed
curl -s https://kubernetes/api/v1/namespaces/default/pods/ --header "Authorization: Bearer $TOKEN" --cacert ca.crt 

# List the services - you should get a 403 status code back
curl -s https://kubernetes/api/v1/namespaces/default/services/ --header "Authorization: Bearer $TOKEN" --cacert ca.crt 
```

## Cleanup

```bash
kubectl delete -f .
```