# gVisor

## Verify that gvisor is installed properly

```bash
containerd config dump | grep plugins.\"io.containerd.grpc.v1.cri\".containerd.runtimes

# You should a get an output similar to this
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc]
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc.options]
```

## Create Runtime Class

Create a different runtime handler, called runsc (gvisor).

```bash
kubectl get runtimeclass ## No resources found

# Inspect the runtime class /root/13_gvisor/runtimeclass.yaml and apply it
kubectl apply -f /root/13_gvisor/runtimeclass.yaml

kubectl get runtimeclass
```

## Make use of a Runtime Classor

Create the pods with `gvisor` runtime class and default `runc` class:

```bash
# Inspect the pods, pay attention to the field `runtimeClassName` and apply both pods
kubectl apply -f /root/13_gvisor/nginx-gvisor-pod.yaml
kubectl apply -f /root/13_gvisor/nginx-pod.yaml
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