# Health Probes

In this training, you will learn about health probes.

The application implements the following health probes:

- `liveness :` http://${INGRESS_IP}/probe_app/liveness
- `readiness:` http://${INGRESS_IP}/probe_app/readiness

Change into the lab directory:

```bash
cd $HOME/trainings/kubernetes_application_development/04_probing
```

## Create the Pod

Inspect pod.yaml and service.yaml definition file and create the pod and the service

```bash
cat k8s/pod.yaml
cat k8s/service.yaml
cat k8s/ingress.yaml
kubectl create -f k8s/
```

## Access the application

```bash
# Access the application
curl -I http://${INGRESS_IP}/probe-app
```

You should get a `HTTP/1.1 200 OK` status code.

## Readiness Probe

We will now change the readiness state of the application. Therefore please open an additional terminal for being able to communicate with the application.

```bash
# [TERMINAL-2] Attach to the application
kubectl attach -it probe-app

# [TERMINAL-2] Set the application to not ready
set unready

# [TERMINAL-1] Check the readiness of the application
kubectl get pods

# [TERMINAL-1] Access the application (this will fail)
curl -I http://${INGRESS_IP}/probe-app
```

> Kubernetes does not route any traffic anymore to the unready Pod. If you would have created the application via a Deployment scaled to 2 replicas the application would still serve traffic on the ready Pod.

## Liveness Probe

We will now change the liveness state of the application. Therefore please open an additional terminal for being able to communicate with the application.

```bash
# [TERMINAL-2] Set the application to dead and wait for ~ 10 seconds
set dead

# [TERMINAL-1] Check the application and note that the container inside the Pod has been restarted
kubectl get pods

# [TERMINAL-1] Access the application
curl -I http://${INGRESS_IP}/probe-app
```

## Cleanup

Delete the created resources.

```bash
kubectl delete -f k8s/ --force --grace-period=0
cd ..
```
