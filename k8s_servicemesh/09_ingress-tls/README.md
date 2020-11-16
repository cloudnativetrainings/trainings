1. Create the certs
```bash
# create root certificate
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=kubermatic training/CN=kubermatic.training' -keyout kubermatic.training.key -out kubermatic.training.crt

# create csr and key
openssl req -out frontend.kubermatic.training.csr -newkey rsa:2048 -nodes -keyout frontend.kubermatic.training.key -subj "/CN=frontend.kubermatic.training/O=kubermatic training"

# create certificate
openssl x509 -req -days 365 -CA kubermatic.training.crt -CAkey kubermatic.training.key -set_serial 0 -in frontend.kubermatic.training.csr -out frontend.kubermatic.training.crt
```

2. Create a Secret in the `istio-system` namespace
```bash
kubectl create -n istio-system secret tls frontend.kubermatic.training --key=frontend.kubermatic.training.key --cert=frontend.kubermatic.training.crt
```

## Inspect and create the resources

```bash
kubectl create -f .
```

4. Curl the backend service and verify the output
```bash
curl -v --resolve "frontend.kubermatic.training:443:$INGRESS_HOST"  --cacert kubermatic.training.crt "https://frontend.kubermatic.training:443/"
```

5. Verify TLS with kiali. Use the External-IP of the kiali and the NodePort. Check the Graph and enable the Security Display Setting. Note that there has to be traffic on the backend service.

6. Clean up
```bash
kubectl delete -f .
kubectl -n istio-system delete secret frontend.kubermatic.training
```
