# There may be Dragons

Although you taught Kubernetes about the proper period of time to do a graceful shutdown data loss can still happen.

In this lab you will learn about a possible reason for data loss.

Change into the lab directory:

```bash
cd $HOME/trainings/kubernetes_fundamentals_for_developers/06_graceful_shutdown_dragons
```

## Create the Pods

Inspect pod-A.yaml and pod-B.yaml definition files and create the pods.

```bash
cat k8s/pod-A.yaml
cat k8s/pod-B.yaml
kubectl create -f k8s/
kubectl get pods
```

> [!NOTE]
> Note that the Applications and the yaml Manifests are exactly the same.

## Watch the log files of the Pods

> [!IMPORTANT]
> Note that `kubectl logs -f ...` command will not work here, due to the logging info will get lost after termination of the Pods.
>
> Note you will additional terminals for doing this.

```bash
# Get the Worker Nodes for the Pods
kubectl get pods -o wide

# SSH into the Worker Nodes where the Pods are running
gcloud compute ssh $(kubectl get pod app-a -o jsonpath='{.spec.nodeName}')

# [WORKER-NODE] Switch to the default logging directory of the Worker Node
cd /var/log/containers

# [WORKER-NODE] Verify the log files are present
ls app-*

# [WORKER-NODE] Tail log file for pod-A
sudo tail -f app-a<TAB>

# Delete the pod-A
kubectl delete pod app-a

# [WORKER-NODE] Tail log file for pod-B
sudo tail -f app-b<TAB>

# Delete the pod-B
kubectl delete pod app-b
```

> [!TIP]
> You can check the logs on Grafana!

## Verification of Graceful Shutdown

Take a look at the logfiles. Did the graceful shutdown happen on both Pods? If not, why?
