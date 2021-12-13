# Health Probes

In this training, you will learn about health probes.

The application implements the following health probes:
* liveness: http://SERVICE_IP:8080/liveness
* readiness: http://SERVICE_IP:8080/readiness

>Navigate to the folder `41_probing` from CLI, before you get started. 

## Create the Pod
Inspect pod.yaml and service.yaml definition file and create the pod and the service
```bash
cat pod.yaml
cat service.yaml
kubectl create -f pod.yaml,service.yaml
```

## Access the application
>Note the Service is of type `LoadBalancer` so it may take a few seconds to get an external ip address.
```bash
# Save the external ip address into an environment variable
export SERVICE_IP=$(kubectl get svc -o jsonpath='{.items[*].status.loadBalancer.ingress[*].ip}')
curl -I http://$SERVICE_IP/
```
You should get a `HTTP/1.1 200 OK` status code.

## Readiness Probe
We will now change the readiness state of the application. Therefore please open an additional terminal for being able to communicate with the application.
```bash
# [TERMINAL-2] Attach to the application
kubectl attach -it my-app  

# [TERMINAL-2] Set the application to not ready
set unready

# [TERMINAL-1] Check the readiness of the application
kubectl get pods

# [TERMINAL-1] Access the application (this will fail)
curl -I http://$SERVICE_IP/
```
>Kubernetes does not route any traffic anymore to the unready Pod. If you would have created the application via a Deployment scaled to 2 replicas the application would still serve traffic on the ready Pod.

## Liveness Probe
We will now change the liveness state of the application. Therefore please open an additional terminal for being able to communicate with the application.

```bash
# [TERMINAL-2] Set the application to dead and wait for ~ 10 seconds
set dead

# [TERMINAL-1] Check the application and note that the container inside the Pod has been restarted
kubectl get pods

# [TERMINAL-1] Access the application 
curl -I http://$SERVICE_IP/
```

## Cleanup
Delete the created resources.
```bash
kubectl delete -f pod.yaml,service.yaml
```
