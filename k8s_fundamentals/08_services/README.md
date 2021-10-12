# Services

## Create and expose the application

### Inspect and create the pod

```bash
kubectl create -f deployment.yaml
```

### Inspect and create the service

```bash
kubectl create -f service-v1.yaml
```

## Take a look at the created endpoints and IPs of the pods

```bash
kubectl get po,ep -o wide
```

## Scale up the deployment

```bash
kubectl scale deployment my-deployment --replicas 3
```

## Take a look at the created Endpoints and IPs of the pods

```bash
kubectl get pod,endpoints -o wide
```

## Access a ClusterIP Service
```bash
# Port forward the service port 80 to the local port 8080
kubectl port-forward service/my-service 8080:80

# You can now access the service (in a seperate terminal)
curl http://127.0.0.1:8080

# You can stop the port-forwarding process via <CTRL>+<C>
```

## Access a NodePort Service

### Inspect and apply the changes to the service

```bash
kubectl apply -f service-v2.yaml
```

### Access the service

```bash
# Get an EXTERNAL-IP of one of the nodes
kubectl get nodes -o wide

# You can now access the service
curl http://<EXTERNAL-IP>:30000
```

## Access a LoadBalancer Service

### Inspect and apply the changes to the service

```bash
kubectl apply -f service-v3.yaml
```

### Access the service

```bash
# Get an EXTERNAL-IP of the service
kubectl get svc 

# You can now access the service
curl http://<EXTERNAL-IP>
```

## Cleanup

```bash
kubectl delete deploy my-deployment
kubectl delete svc my-service
```

[Jump to Home](../README.md) | [Previous Training](../07_revision-history/README.md) | [Next Training](../09_configmaps/README.md)