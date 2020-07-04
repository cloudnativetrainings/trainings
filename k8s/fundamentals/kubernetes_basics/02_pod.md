# Pods

In this training we will create a Pod and access it via curl

***NOTE:*** On GCP you may have to open the firewall with the default node-port range of Kubernetes - see [setup_cluster.sh to add firewall rule](../../setup_cluster.sh) or use the Service type `LoadBalancer`.

## 1. Create the file pod.yaml

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

## 2. Apply the Pod to your cluster

```bash
kubectl create -f pod.yaml
```

## 3. Expose the Pod

```bash
kubectl expose pod my-pod --type NodePort
```

## 4. Access the application

```bash
## get the external IP address of the node
kubectl get nodes -o wide

## get the port of the application
kubectl get services

## curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>:<PORT>
```

## Extra: Learn kubectl

### 1. Getting help

```bash
# Getting info and examples for the 'get' command
kubectl get --help
# Get info about a specific yaml structure
kubectl explain pod.metadata.name
# Get short info about a specific yaml structure
kubectl explain --recursive pod.spec.containers.ports
```

### 2. Getting Pod Information

```bash
## show all Pods
kubectl get pods

## show all Pods with labels
kubectl get pods --show-labels

## show all Pods with IP address
kubectl get pods -o wide

## store a Pod's yaml definition into a file
kubectl get pod my-pod -o yaml > pod.yaml
```

### 3. Describe a Pod

```bash
kubectl describe pod my-pod
```

### 4. Debugging Pods

```bash
## get logs of a Container
kubectl logs my-pod

## follow the logs of a Container
kubectl logs -f my-pod

## exec into a Container
kubectl exec -it my-pod -- bash
```

### 4. Delete Pods and Services

```bash
kubectl delete pod,service my-pod
```
