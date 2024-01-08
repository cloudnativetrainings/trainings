# Ephemeral Containers

Ephemeral containers are a special type of container that runs temporarily in an existing Pod to accomplish user-initiated actions such as troubleshooting. It's stable since Kubernetes v1.25

Change into the lab directory:

```bash
cd $HOME/trainings/kubernetes_application_development/08_ephemeral_containers
```

## Distroless Images

"Distroless" images contain only your application and its runtime dependencies. They do not contain package managers, shells or any other programs you would expect to find in a standard Linux distribution.

Create the pod, which used a `distroless` image as base:

```bash
kubectl create -f k8s/pod.yaml
```

Try to exec into the pod:

```bash
kubectl exec -it my-app -- /bin/bash
# output:
#error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "4c8f03ad4def2bae279f9fee4048ba0306edc1c0ce6ad8feba8cc584dd90f36e": OCI runtime exec failed: exec failed: unable to start container process: exec: "/bin/bash": stat /bin/bash: no such file or directory: unknown

kubectl exec -it my-app -- /bin/sh
#error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "09b235d1cae19118a9a31d6f01695ec16dbf3493bfd258515e2ca51bc1b376d8": OCI runtime exec failed: exec failed: unable to start container process: exec: "/bin/sh": stat /bin/sh: no such file or directory: unknown

kubectl exec -it my-app -- /bin/ls -l /
#error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "72d5f76e7139011df893e43e619ba3b57a0b18cd8af4e4f7142fa4cf8dbbf91a": OCI runtime exec failed: exec failed: unable to start container process: exec: "/bin/ls": stat /bin/ls: no such file or directory: unknown
```

## Debug containers to the rescue

Run below command to attach a new container to the existing one:

```bash
kubectl debug -it my-app --image=busybox:1.28 --target=my-app
#Targeting container "my-app". If you don't see processes from this container it may be because the container runtime doesn't support this feature.
#Defaulting debug container name to debugger-d462g.

#If you don't see a command prompt, try pressing enter.

#/ #
```

Run below commands inside the container:

```bash
ps -ef

ls -l

cd /proc/1/root

ls -l
```

## Access to the host with ephemeral containers

Create a shell on the node:

```bash
# First select one of the nodes:
kubectl get nodes

# Then start the shell:
kubectl debug node/<NODE_NAME> -it --image=ubuntu
```

## Cleanup

Delete all pods:

```bash
kubectl delete pods --all
cd ..
```

---

Jump > [Init Containers](../07_init_containers/README.md) | Next > [Kubernetes API](../09_k8s_api/README.md)
