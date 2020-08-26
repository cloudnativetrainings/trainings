# StatefulSets

## Inspect the [service yaml file](./service.yaml) and create the service

```bash
kubectl create -f service.yaml
```

## Inspect the [sts yaml file](./sts.yaml) and create the sts

```bash
kubectl create -f sts.yaml
```

## Watch the creation of the resources

Take note that the replicas are created one by one and not all at the same time.

```bash
watch -n 1 kubectl get sts,pv,pvc,pods
```

## Printout the content of the state file of the last built pod

```bash
kubectl exec -it my-statefulset-2 -- cat /app/state
pod my-statefulset-2 - 10.24.0.36
pod my-statefulset-2 - 10.24.0.36
```

## Scale down the StatefulSet

```bash
kubectl scale sts my-statefulset --replicas 2
```

## Watch the deletion of the resources

Note that the pv and the pvc will not get deleted.

```bash
watch -n 1 kubectl get sts,pv,pvc,pods
```

## Scale up the statefulset

```bash
kubectl scale sts my-statefulset --replicas 3
```

## Printout the content of the state file of the last built pod

Take note that the same pv and pvc got bound to the pod but the IP of the pod has changed. 

```bash
kubectl exec -it my-statefulset-2 -- cat /app/state
pod my-statefulset-2 - 10.24.0.36
pod my-statefulset-2 - 10.24.0.36
pod my-statefulset-2 - 10.24.0.37
```

## Get IPs of all pods of the statefulset
```bash
kubectl exec -it my-statefulset-2 -- nslookup my-statefulset-service 
```

## Get IPs of all pods for the statefulset
```bash
kubectl run -it nslookup --image busybox:1.32.0 --restart=Never --rm -- nslookup my-service
```

## Get a specific IP of a pod of the statefulset
```bash
kubectl run -it nslookup --image busybox:1.32.0 --restart=Never --rm -- nslookup my-sts-0.my-service
```

## Clean up
```bash
kubectl delete svc,sts,pv,pvc --all
```
