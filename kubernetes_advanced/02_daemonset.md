# DaemonSets

1. Create the following DaemonSet
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: my-daemonset
spec:
  selector:
    matchLabels:
      name: my-daemonset
  template:
    metadata:
      labels:
        name: my-daemonset
    spec:
      containers:
        - name: who-am-i
          image: busybox
          command: 
            - "/bin/sh"
          args: 
            - "-c"
            - "while true; do echo $MY_NODE_NAME running pod $MY_POD_NAME; sleep 10; done;"
          env:
            - name: MY_NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: MY_POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
```
```bash
kubectl create -f daemonset.yaml
```
2. Take a look at your Pods and Nodes. You should get something similar like this:
```bash
kubectl get po,no
NAME                     READY   STATUS    RESTARTS   AGE
pod/my-daemonset-4whdw   1/1     Running   0          38m
pod/my-daemonset-l7fqj   1/1     Running   0          38m
pod/my-daemonset-v2djc   1/1     Running   0          38m

NAME                                                  STATUS   ROLES    AGE     VERSION
node/gke-hubert-markdown-default-pool-068b6f1c-qvw8   Ready    <none>   7h52m   v1.14.8-gke.2
node/gke-hubert-markdown-default-pool-068b6f1c-t26g   Ready    <none>   7h52m   v1.14.8-gke.2
node/gke-hubert-markdown-default-pool-068b6f1c-z0hc   Ready    <none>   7h52m   v1.14.8-gke.2
```
3. Choose one pod and take a look at its logging
```bash
kubectl logs <POD-NAME>
```
4. Clean up
```bash
kubectl delete ds --all
```
