# Expose an application via Istio

# Inspect and create the resources

```bash
kubectl create -f .
```

# Verify everything is working (you can also visit the URL in a browser)

```bash
curl $INGRESS_HOST
```

# Verify the sync state of the proxies

```bash
istioctl proxy-status
```

# Verify the curl request in the log files of the `ingressgateway` pod

```bash
kubectl -n istio-system logs <ISTIO-INGRESS-GATEWAY-POD>
```

# Verify the curl request in the log files of the `istio-proxy` container

```bash
kubectl logs <FRONTEND-POD> -c istio-proxy
```

# Verify the curl request in the log files of the `frontend` container

```bash
kubectl logs <FRONTEND-POD> -c frontend
```

# Clean up

```bash
kubectl delete -f .
```
