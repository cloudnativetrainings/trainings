1. Apply the yaml files
```bash
kubectl apply -f .
```

2. Curl the api 
```bash
curl $INGRESS_HOST/api
```

3. Set the api unavailable
```bash
curl $INGRESS_HOST/set_available/false
```

4. Curl the api 
```bash
curl $INGRESS_HOST/api
```

5. Uncomment the `trafficPolicy` section in the DestinationRule and apply the changes
```bash
kubectl apply -f .
```

6. Curl the api 
```bash
curl $INGRESS_HOST/api
```

7. Take a look at the log files of the `backend` container. Note that there are more than one requests to the api

8. Curl the api  and note the different response
```bash
curl $INGRESS_HOST/api
```

9. Wait a minute, until the CircuitBreaker is in closed state again and curl the api again
```bash
curl $INGRESS_HOST/api
```

10. Clean up
```bash
kubectl delete -f .
```
