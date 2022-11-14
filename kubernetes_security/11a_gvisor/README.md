# gVisor

## Create Runtime Class
Create a different runtime handler, called runsc (gvisor).

```bash
kubectl get runtimeclass ## No resources found

cat <<EOF | kubectl apply -f -
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  # The name the RuntimeClass will be referenced by.
  # RuntimeClass is a non-namespaced resource.
  name: gvisor 
# The name of the corresponding CRI configuration
handler: runsc
EOF

kubectl get runtimeclass
```

Create the pods with `gvisor` runtime class and default `runc` class:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
    - image: nginx:1.23.0
      name: nginx
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx-gvisor
spec:
  runtimeClassName: gvisor
  containers:
    - image: nginx:1.23.0
      name: nginx
EOF
```

## Check if gVisor is working

Check the pod's kernel version with gvisor

```bash
kubectl exec -it nginx-gvisor -- /bin/bash

uname -r   # shows kernel release

exit
```

Check the pod's kernel version without gvisor

```bash
kubectl exec -it nginx -- /bin/bash

uname -r   # shows kernel release

exit
```

Check node's kernel version

```bash
uname -r
```

Note that gVisor has a different kernel version that the node and the other pod.

## Cleanup

```bash
kubectl delete pod nginx
kubectl delete pod nginx-gvisor
```