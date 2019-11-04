# Commands and Args
In this training we will create a customized Pod

1. Create a file called `customized-image-pod.yaml` with the following content
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: customized-image-pod
spec:
  containers:
    - name: customized-image-container
      image: busybox
```
2. Apply the Pod to your cluster
```bash
kubectl create -f pod.yaml
```
3. Take a look at the Pods. Why is the Pod not in state `RUNNING`?
```bash
kubectl get pods
```
4. Get more info about the Pod. Pay attention to the structure  `Last State:`
```bash
kubectl describe pod customized-image-pod | grep -A4 "Last State:"
```
5. Add the following `command` and `args` to the container
```yaml
...
- name: customized-image-container
  image: busybox
  command: [ "echo" ]
  args: [ "hello k8s" ]
```
6. Delete and re create the Pod
```bash
kubectl delete pod customized-image-pod
kubectl create -f customized-image-pod.yaml
```
7. Get the logs of the Container
```bash
kubectl logs customized-image-pod
```
8. Cleanup
```bash
kubectl delete pod customized-image-pod
```