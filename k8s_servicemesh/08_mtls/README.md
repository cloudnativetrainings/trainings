# Mutual TLS

In this task you will learn how to cusomize mutul TLS and how to verify if communication is encrypted.

By default mtls is enabled in istio.

## Inspect and create the resources

```bash
kubectl create -f .
```

## Encrypted communication

### Verify via the application

#### Curl the api and note the client cert header

```bash
curl -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST/mtls
```

Note an output like this verifies tls communication
```
mtls request - client cert header By=spiffe://cluster.local/ns/training/sa/default;Hash=7a27fff898812a54990ae99edd24346880a7c1614cf031077139f68ca571d0a9;Subject="";URI=spiffe://cluster.local/ns/istio-system/sa/istio-ingressgateway-service-account
```

#### Curl the api from the `frontend` container and note the client cert header

```bash
kubectl exec -it <FRONTEND-POD> -c frontend -- curl backend:8080/mtls
```

Note an output like this verifies tls communication
```
mtls request - client cert header By=spiffe://cluster.local/ns/training/sa/default;Hash=7a27fff898812a54990ae99edd24346880a7c1614cf031077139f68ca571d0a9;Subject="";URI=spiffe://cluster.local/ns/istio-system/sa/istio-ingressgateway-service-account
```

### Verify via Kiali

```bash
istioctl dashboard kiali
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.

#### Put some traffic onto our services

Do this in seperate cloud shells.

```bash
while true; do curl -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST/mtls; sleep 5; done
```

```bash
while true; do kubectl exec -it <FRONTENT-POD> -c frontend -- curl backend:8080/mtls; sleep 5; done
```

#### Verify TLS with Kiali

Check the Graph and enable the Security Display Setting. There has to be a TLS symbol on the edges.

## Unencrypted communication

### Costumize the namespace `training`

Create the `disable-tls.yaml` file and create the PeerAuthentication.

```yaml
apiVersion: "security.istio.io/v1beta1"
kind: "PeerAuthentication"
metadata:
  namespace: training
  name: disable
spec:
  mtls:
    mode: DISABLE
```

```bash
kubectl create -f disable-tls.yaml
```
### Verify via the application

Verify your Cloud Shell curling the backend application directly.

Note an output like this verifies tls communication
```
mtls request - no client cert header
```

Verify your Cloud Shell curling the backend application from the frontend container.

Note an output like this verifies tls communication
```
mtls request - no client cert header
```

### Verify via Kiali

```bash
istioctl dashboard kiali
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.

#### Verify TLS with Kiali

Check the Graph and enable the Security Display Setting. There has to be no TLS symbol on the edges.

## Clean up

Stop curl-while-loops in the Cloud Shells.

```bash
kubectl delete -f .
```
