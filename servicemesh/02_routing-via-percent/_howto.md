1. Create version frontend 2.0.0

2. Apply the deployments

3. Apply the VS & DR

4. curl the application
```bash
while true; do curl $INGRESS_HOST; sleep 1; done;
```

5. Change the percentate in the VS

6. curl the application
```bash
while true; do curl $INGRESS_HOST; sleep 1; done;
```

7. Clean up
```bash
kubectl delete -f .
```



# good to know 

## DestinationRule
Labels apply a filter over the endpoints of a service in the service registry. See route rules for examples of usage.

```bash
kubectl get endpoints --show-labels
```

