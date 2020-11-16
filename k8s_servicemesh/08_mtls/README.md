## Inspect and create the resources

```bash
kubectl create -f .
```

2. Curl the api and note the client cert header
```bash
curl -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST/mtls
```

3. Curl the api from the `frontend` container and note the client cert header
```bash
kubectl exec -it <FRONTEND-POD> -c frontend -- curl backend:8080/mtls
```

4. Make kiali available - change the type from ClusterIP to LoadBalancer and set the port to the same as the NodePort Port

5. Verify TLS with kiali. Use the External-IP of the kiali and the NodePort. Check the Graph and enable the Security Display Setting. Note that there has to be traffic on the backend service.

6. Verify TLS via istioctl
istioctl x authz check <BACKEND-POD>.training

7. Change the mode of the PeerAuthentication to DISABLE and apply the changes
change peerauthentication and apply
```bash
kubectl apply -f .
```

8. Curl the api and note the client cert header
```bash
curl -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST/mtls
```

9. Curl the api from the `frontend` container and note the client cert header
```bash
kubectl exec -it <FRONTEND-POD> -c frontend -- curl backend:8080/mtls
```

10. Verify TLS with kiali. Use the External-IP of the kiali and the NodePort. Check the Graph and enable the Security Display Setting. Note that there has to be traffic on the backend service.

11. Verify TLS via istioctl
istioctl x authz check <BACKEND-POD>.training

12. Clean up
```bash
kubectl delete -f .
```
