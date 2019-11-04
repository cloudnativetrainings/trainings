# DaemonSets
In the course we will deploy an efk stack to get logs from our applications.

1. Create namespace `logging`
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
