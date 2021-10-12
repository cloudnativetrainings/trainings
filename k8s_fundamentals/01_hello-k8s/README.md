# Hello K8s

In this course we will create an application which will be reachable in the WWW.

## Create and expose the application

### Inspect and create the pod

```bash
kubectl create -f pod.yaml
```

### Inspect and create the service

```bash
kubectl create -f service.yaml
```

## Access the application

```bash
kubectl get services

# copy the EXTERNAL-IP of your service

# curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>
```

## Modify the application

```bash
## copy the index.html file into the pod
kubectl cp index.html my-pod:/usr/share/nginx/html/index.html

## curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>
```

## Cleanup

```bash
kubectl delete pod my-pod
kubectl delete service my-service
```

[Jump to Home](../README.md) | [Next Training](../02_pods/README.md)