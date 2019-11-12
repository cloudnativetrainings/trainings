# Commands and Args
In this training we will create a customized Pod

1. Create a file called `pod.yaml` with the following content
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: busybox
```
2. Create the Pod.
```bash
kubectl create -f customized-image-pod.yaml
```
3. Take a look at the Pods. Why is the Pod not in state `RUNNING`?
```bash
kubectl get pods
```
4. Get more info about the Pod. Pay attention to the structure  `Last State:`
```bash
kubectl describe pod my-pod | grep -A4 "Last State:"
```
5. Add the following `command` and `args` to the container
```yaml
...
- name: my-container
  image: busybox
  command: [ "sleep" ]
  args: [ "600" ]
```
6. Delete and re create the Pod
```bash
kubectl delete pod my-pod
kubectl create -f my-pod.yaml

#alternative
kubectl replace --force -f my-pod.yaml
```
7. Cleanup
```bash
kubectl delete pod my-pod
```