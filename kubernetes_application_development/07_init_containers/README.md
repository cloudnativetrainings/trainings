# Init Containers

Init containers can contain utilities or setup scripts not present in an app image.

Change into the lab directory:

```bash
cd $HOME/trainings/kubernetes_application_development/07_init_containers
```

## Deploy apps

First, check the pod definitions:

```bash
cat k8s/pod-A.yaml
cat k8s/pod-B.yaml
```

Create the `pod-a`:

```bash
kubectl create -f k8s/pod-A.yaml
```

Check the status, you will see that it's in `Init` state:

```bash
kubectl get pods

# output:
#NAME    READY   STATUS     RESTARTS   AGE
#pod-a   0/1     Init:0/1   0          4s
```

Check the logs for the init container:

> [!IMPORTANT]
> Do this in a seperate terminal.

```bash
kubectl logs pod-a -c wait-for-pod-b -f
```

Now, create the `pod-b` and it's service

```bash
kubectl create -f k8s/pod-B.yaml
kubectl create -f k8s/service-B.yaml
```

You will see the ready message on the other terminal!

## Cleanup

Remove the pods and the service:

```bash
kubectl delete -f k8s/
cd ..
```

---

Jump > [OOM](../06_oom/README.md) | Next > [Debug Containers](../08_ephemeral_containers/README.md)
