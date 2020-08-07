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

4. Curl the api and check the latency of the response
```bash
curl $INGRESS_HOST/api
```

5. Uncomment the timeout in the VirtualService and apply the change
```bash
kubectl apply -f .
```

6. Curl the api and note that we get a timeout response
```bash
curl $INGRESS_HOST/api
```

7. Clean up
```bash
kubectl delete -f .
```