1. Apply the yaml files. 
```bash
kubectl apply ...
```

2. Make calls to the cat api. If you do not want to miss a cute cat click the link you get in the response.
```bash
while true; do curl -H "Host: frontend.training.svc.cluster.local" $INGRESS_HOST/cats; sleep 10; done;
```

3. Make prometheus available - change the type from ClusterIP to LoadBalancer and set the port to the same as the NodePort Port

5. Make grafana available - change the type from ClusterIP to LoadBalancer and set the port to the same as the NodePort Port

6. Make jaeger available (the service is called tracing) - change the type from ClusterIP to LoadBalancer and set the port to the same as the NodePort Port

7. Play around with those tools

8. Clean up
```bash
kubectl delete -f .
```
