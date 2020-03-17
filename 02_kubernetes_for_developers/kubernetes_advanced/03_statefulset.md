# Stateful Sets

1. Create the following Stateful Set and its headless Service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-stateful-set
  labels:
    app: my-stateful-set
spec:
  ports:
    - port: 80
  clusterIP: None
  selector:
    app: my-stateful-set
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: my-stateful-set
spec:
  serviceName: my-stateful-set
  replicas: 3
  selector:
    matchLabels:
      app: my-stateful-set
  template:
    metadata:
      labels:
        app: my-stateful-set
    spec:
      terminationGracePeriodSeconds: 0
      containers:
        - name: my-stateful-set
          image: busybox
          command: 
            - "/bin/sh"
          args: 
            - "-c"
            - "while true; do echo pod $MY_POD_NAME - $MY_POD_IP >> /tmp/state; sleep 10; done;"
          env:
            - name: MY_POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: MY_POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
          volumeMounts:
            - name: state
              mountPath: /tmp
  volumeClaimTemplates:
    - metadata:
        name: state
      spec:
        accessModes: [ "ReadWriteOnce" ]
        resources:
          requests:
            storage: 1Gi
```
```bash
kubectl create -f sts.yaml
```
2. Watch the creation of the resources. Take note that the replicas are created one by one and not all at the same time.
```bash
watch -n 1 kubectl get sts,pv,pvc,pods
```
3. Printout the content of the state file of the last built Pod.
```bash
kubectl exec -it my-stateful-set-2 -- cat /tmp/state
pod my-stateful-set-2 - 10.24.0.36
pod my-stateful-set-2 - 10.24.0.36
```
4. Scale down the StatefulSet.
```bash
kubectl scale sts my-stateful-set --replicas 2
```
4. Scale up the StatefulSet.
```bash
kubectl scale sts my-stateful-set --replicas 3
```
5. Printout the content of the state file of the last built Pod. Take note that the same PersistentVolume got bound to the Pod.
```bash
kubectl exec -it my-stateful-set-2 -- cat /tmp/state
pod my-stateful-set-2 - 10.24.0.36
pod my-stateful-set-2 - 10.24.0.36
pod my-stateful-set-2 - 10.24.0.37
```
Note that the IP has changed, but we have still same hostname and FQN.

6. Find out the FQN of your 3rd stateful pod:
```bash
kubectl exec -it my-stateful-set-0 -- nslookup TODO_FQN
### potential output
Server:		10.23.240.10
Address:	10.23.240.10:53

Non-authoritative answer:
Name:	xxx.xxx.xxx.svc.cluster.local
Address: 10.24.0.37
```
7. Clean up
```bash
kubectl delete sts,pv,pvc
```
