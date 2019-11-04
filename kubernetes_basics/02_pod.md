# Pods
In this training we will create a Pod and access it via curl

1. Create a file called `pod.yaml` with the following content
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    app: my-pod
spec:
  containers:
    - name: my-container
      image: nginx
      ports:
        - containerPort: 80
          protocol: TCP
```
2. Apply the Pod to your cluster
```bash
kubectl create -f pod.yaml
```
3. Expose the Pod
```bash
kubectl expose pod my-pod --type NodePort
```
4. Access the application
```bash
# Get the external IP address of the node
kubectl get nodes -o wide
# Get the port of the application
kubectl get services
# Curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>:<PORT>
```

# Learn kubectl

1. Getting help
```bash
# Getting info and examples for the 'get' command
kubectl get --help
# Get info about a specific yaml structure
kubectl explain pod.metadata.name
# Get short info about a specific yaml structure
kubectl explain --recursive pod.metadata.ports
```
2. Getting Pod Information
```bash
# Show all Pods
kubectl get pods
# Show all Pods with labels
kubectl get pods --show-lables
# Show all Pods with IP address
kubectl get pods -o wide
# Store a Pod's yaml definition into a file
kubectl get pod my-pod -o yaml > pod.yaml
```
3. Describe a Pod
```bash
kubectl describe pod my-pod
```
4. Debugging Pods
```bash
# Get Logs of a Container
kubectl logs my-pod
# Follow the logs of a Container
kubectl logs -f my-pod
# Exec into a Container
kubectl exec -it my-pod -- bash
```
4. Delete Pods and Services
```bash
kubectl delete pod,service my-pod
```
