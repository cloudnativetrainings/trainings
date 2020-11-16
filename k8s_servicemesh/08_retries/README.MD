1. Apply the yaml files
```bash
kubectl apply -f .
```

2. Curl the api 
```bash
curl $INGRESS_HOST/api
```

3. Set the delay of the api to 10 seconds
```bash
curl $INGRESS_HOST/set_delay/10
```

4. Uncomment the `timeout` and the `retries` section of the VirtualService and apply the change
```bash
kubectl apply -f .
```

5. Open a second terminal and watch the logfiles of the backend container
```bash
# Second terminal
kubectl logs -f <BACKEND-POD> -c backend
```

6. Curl the api and watch the logs in the second terminal 
```bash
# First terminal
curl $INGRESS_HOST/api
```

7. Clean up
```bash
kubectl delete -f .
```