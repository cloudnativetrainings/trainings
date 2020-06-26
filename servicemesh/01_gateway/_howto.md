1. Build and push eu.gcr.io/loodse-training-playground/loodse-training/frontend:1.0.0

1. Get public ip of istio-ingressgateway
```bash
kubectl get svc -n istio-system | grep istio-ingressgateway
```
2. Edit the host of the Gateway and the VirtualService

3. Apply the Gateway and the VirtualService

4. Verify the application is running via the browser

5. Clean up
```bash
kubectl delete -f .
```
