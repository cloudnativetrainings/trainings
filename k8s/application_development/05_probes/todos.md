1. Ensure you are using the right Container Registry

2. Apply the yaml files in the k8s folder

3. Send a /set_ready/false request

4. Berify READY via 'kubectl get pods'

5. Send a /set_healthy/false request

6. Verify restart via 'kubectl get pods'