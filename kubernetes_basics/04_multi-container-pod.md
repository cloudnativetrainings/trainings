# Multi Container Pod
In this training we will work with a Pod containing 2 containers.

1. Create a file called `multi-container-pod.yaml` with the following content
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
spec:
  containers:
    - name: container-a
      image: busybox
      command:
        - "/bin/sh"
      args:
        - "-c"
        - "while true; do echo hello A; sleep 1; done;"
    - name: container-b
      image: busybox
      command:
        - "/bin/sh"
      args:
        - "-c"
        - "while true; do echo hello B; sleep 1; done;"
```
2. Get the logs of the Pod. This will not work, please follow the instructions and consult --help.
```bash
kubectl logs -f multi-container-pod 
```
3. Exec into the Pod. Pay attention to the output. 
```bash
kubectl exec -it multi-container-pod -- /bin/sh
Defaulting container name to container-a.
Use 'kubectl describe pod/multi-container-pod -n default' to see all of the containers in this pod.
```
4. Find out how to exec into Container-B of the Pod.
5. Share a directory between 2 Containers in a Pod.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
spec:
  containers:
    - name: container-a
      image: busybox
      command:
        - "/bin/sh"
      args:
        - "-c"
        - "while true; do echo $(date) > /tmp/buffer; sleep 1; done;"
      volumeMounts:
        - name: buffer
          mountPath: /tmp
    - name: container-b
      image: busybox
      command:
        - "/bin/sh"
      args:
        - "-c"
        - "while true; do cat /tmp/buffer; sleep 1; done;"
      volumeMounts:
        - name: buffer
          mountPath: /tmp
  volumes:
    - name: buffer
      emptyDir: {}
```  
6. Cleanup
```bash
kubectl delete pod multi-container-pod
```