## Inspect and create the resources

```bash
kubectl create -f .
```

2. Curl the api 
```bash
curl $INGRESS_HOST/api
```

3. Uncomment the `fault` section of the VirtualService and apply the changes
```bash
kubectl apply -f .
```

4. Curl the api, note that there are only unsuccessfull responses
```bash
curl $INGRESS_HOST/api
```

5. Play around with the fault percentages in the VirtualServices (eg set them to 50 %) and apply the changes 
```bash
kubectl apply -f .
```

6. Curl the api, note the behaviour is now rather random
```bash
curl $INGRESS_HOST/api
```

7. Clean up
```bash
kubectl delete -f .
```