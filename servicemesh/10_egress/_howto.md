1. Apply the yaml files. Do not apply the google-serviceentry.yaml file yet.
```bash
kubectl apply ...
```

2. Curl via the `backend` container. Note that you get a vaild response.
```bash
kubectl exec -it <BACKEND-POD> backend -- curl https://www.google.com
```

3. Verify the call to the external service in Kiali

4. Get the Istio ConfigMap
```bash
kubectl -n istio-system  get cm istio -o yaml > 10_egress/istio-cm.yaml
```

5. Change theconfigmap in the `mesh` section. Note that this change can take some time to take effect.
```yaml
    outboundTrafficPolicy:
      mode: REGISTRY_ONLY
```

6. Curl via the `backend` container. Note that you do not get a valid response.
```bash
kubectl exec -it <BACKEND-POD> backend -- curl https://www.google.com
```

7. Verify the call to the external service in Kiali

8. Apply the google-serviceentry.yaml file
```bash
kubectl apply -f .
```

9. Curl via the `backend` container. Note that you get a response.
```bash
kubectl exec -it <BACKEND-POD> backend -- curl https://www.google.com
```

10. Verify the call to the external service in Kiali

11. Clean up
```bash
kubectl delete -f .
```