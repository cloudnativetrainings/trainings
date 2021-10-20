# StatefulSets

In the training, we will learn about Statefulsets.

>Navigate to the folder `14_statefulsets` from CLI, before you get started. 

## Scaling

### Create service and statefulset
* Inspect service.yaml definition file and create the service
  ```bash
  cat service.yaml
  kubectl create -f service.yaml
  ```

* Inspect and create the sts
  ```bash
  kubectl create -f sts.yaml
  ```

* Watch the creation of the resources
  >Take note that the replicas are created one by one and not all at the same time.
  ```bash
  watch -n 1 kubectl get sts,pv,pvc,pods
  ```

* Print the content of the state file of the last built pod
  ```bash
  kubectl exec -it my-sts-2 -- cat /app/state
  ```

###  Scale down the statefulset
* Scale down the statefulset 
  ```bash
  kubectl scale sts my-sts --replicas 2
  ```

* Watch the deletion of the resources
  >Note that the pv and the pvc will not get deleted.
  ```bash
  watch -n 1 kubectl get sts,pv,pvc,pods
  ```

### Scale up the statefulset

* Scale up the statefulset 
  ```bash
  kubectl scale sts my-sts --replicas 3
  ```

* Printout the content of the state file of the last built pod
  >Take note that the same pv and pvc got bound to the pod but the IP of the pod has changed. 
  ```bash
  kubectl exec -it my-sts-2 -- cat /app/state
  ```

## Headless Service

### Get IPs of all pods of the statefulset

```bash
kubectl run -it nslookup --image nicolaka/netshoot --restart=Never --rm -- nslookup my-service
```

### Get a specific IP of a pod of the statefulset
```bash
kubectl run -it nslookup --image nicolaka/netshoot --restart=Never --rm -- nslookup my-sts-0.my-service
```

## Clean up
```bash
kubectl delete svc,sts,pv,pvc --all
```

[Jump to Home](../README.md) | [Previous Training](../13_persistence-use-volume/README.md) | [Next Training](../15_hpas/README.md)