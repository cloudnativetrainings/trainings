1. Apply the yaml files
```bash
kubectl apply -f .
```

2. Curl the application
```bash
curl -H "user: bob" $INGRESS_HOST
```

3. Verify that the request got a response from Version 1.0.0

4. Curl the application
```bash
curl -H $INGRESS_HOST
```

5. Verify that the request got a response from Version 2.0.0

6. Clean up
```bash
kubectl delete -f .
```