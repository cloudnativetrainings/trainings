1. Ensure you are using the right Container Registry

2. Apply the yaml files in the k8s folder

3. Stop the Pod

4. Check the logs of the Pod. The app has not enough time to gracefully shutdown. Fix this.

5. Take a look at 'kubectl get events' - it looks that there are failing readiness probes

6. Add a delay, so the application can start up properly