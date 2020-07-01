1. Create version frontend 2.0.0

2. Apply the deployments

3. Apply the VS & DR

4. curl the application
```bash
curl -H "user: bob" $INGRESS_HOST
```

6. curl the application
```bash
curl -H $INGRESS_HOST
```

7. Clean up
```bash
kubectl delete -f .
```