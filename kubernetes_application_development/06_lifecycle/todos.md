1. Ensure you are using the right Container Registry

2. Apply the yaml files in the k8s folder

3. Fix the ENTRYPOINT in the Dockerfile

4. Stop the Pod

5. Check the logs of the Pod. The app has not enough time to gracefully shutdown. Fix this.

6. Take a look at 'kubectl get events' - it looks that there are failing readiness probes

7. Add a delay, so the application can start up properly