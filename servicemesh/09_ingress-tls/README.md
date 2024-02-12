# Ingress TLS

In this task you will setup a certificate to be used for inbound traffic.

## Create the certs

```bash
# create root certificate
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=kubermatic training/CN=cloud-native.training' -keyout cloud-native.training.key -out cloud-native.training.crt

# create csr and key
openssl req -out frontend.cloud-native.training.csr -newkey rsa:2048 -nodes -keyout frontend.cloud-native.training.key -subj "/CN=frontend.cloud-native.training/O=kubermatic training"

# create certificate
openssl x509 -req -days 365 -CA cloud-native.training.crt -CAkey cloud-native.training.key -set_serial 0 -in frontend.cloud-native.training.csr -out frontend.cloud-native.training.crt
```

## Create a Secret in the `istio-system` namespace

```bash
kubectl create -n istio-system secret tls frontend.cloud-native.training --key=frontend.cloud-native.training.key --cert=frontend.cloud-native.training.crt
```

## Inspect and create the resources

```bash
kubectl create -f .
```

## Verify inbound TLS

### Verify via curl

```bash
while true; do curl -v --resolve "frontend.cloud-native.training:443:$INGRESS_HOST" --cacert cloud-native.training.crt "https://frontend.cloud-native.training:443/"; sleep 5; done
```

#### Verify TLS with Kiali

```bash
istioctl dashboard kiali
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.

Check the Graph and enable the Security Display Setting. There has to be a TLS symbol on the edges.

## Curl the backend service and verify the output

```bash
curl -v --resolve "frontend.cloud-native.training:443:$INGRESS_HOST"  --cacert cloud-native.training.crt "https://frontend.cloud-native.training:443/"
```

## Clean up

```bash
kubectl delete -f .
kubectl -n istio-system delete secret frontend.cloud-native.training
```
