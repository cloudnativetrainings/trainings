1. Apply the yaml files
```bash
kubectl apply -f .
```

2. Verify everything is working (you can also visit the URL in a browser)
```bash
curl $INGRESS_HOST
```

3. Verify the sync state of the proxies
```bash
istioctl proxy-status
```

4. Verify the curl request in the log files of the `ingressgateway` pod
```bash
kubectl -n istio-system logs <ISTIO-INGRESS-GATEWAY-POD>
```

5. Verify the curl request in the log files of the `istio-proxy` container
```bash
kubectl logs <FRONTEND-POD> -c istio-proxy
```

6. Verify the curl request in the log files of the `frontend` container
```bash
kubectl logs <FRONTEND-POD> -c frontend
```

7. Clean up
```bash
kubectl delete -f .
```
