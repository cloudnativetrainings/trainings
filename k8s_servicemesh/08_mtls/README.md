# Mutual TLS

In this task you will learn how to cusomize mutul TLS and how to verify if communication is encrypted.

By default mtls is enabled in istio.

## Inspect and create the resources

```bash
kubectl create -f .
```

## Verify encrypted communication

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

#### Install Kiali

```bash
# Kiali is depending on Prometheus, so you have to install Prometheus upfront
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/prometheus.yaml
# Install Kiali, not you have to apply the yaml twice due to CRDs
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/kiali.yaml
```

#### Adapt the Kiali Service

By default the Kiali is of type ClusterIP. Let's change this. Change the service type from `ClusterIP` to `LoadBalancer` and set the `port` and the `nodePort` in the http port both to 30000 like this:

```yaml
spec:
  ...
  ports:
  - name: http
    nodePort: 30000
    port: 30000
    protocol: TCP
    targetPort: 20001
  ...
  type: LoadBalancer
```

```bash
kubectl -n istio-system edit svc kiali 
```


-----> do bin i...



2 tabs
while true; do curl -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST/mtls; sleep 5; done
while true; do kubectl exec -it frontend-1.0.0-7ffd58595c-w5q2d -c frontend -- curl backend:8080/mtls; sleep 5; done



## Verify TLS with kiali. Use the External-IP of the kiali and the NodePort. Check the Graph and enable the Security Display Setting. Note that there has to be traffic on the backend service.


```yaml
apiVersion: "security.istio.io/v1beta1"
kind: "PeerAuthentication"
metadata:
  namespace: training
  name: disable
spec:
  mtls:
#    mode: DISABLE
```

## Change the mode of the PeerAuthentication to DISABLE and apply the changes

Change peerauthentication and apply

```bash
kubectl apply -f .
```

## Curl the api and note the client cert header

```bash
curl -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST/mtls
```

## Curl the api from the `frontend` container and note the client cert header

```bash
kubectl exec -it <FRONTEND-POD> -c frontend -- curl backend:8080/mtls
```

## Verify TLS with kiali. Use the External-IP of the kiali and the NodePort. Check the Graph and enable the Security Display Setting. Note that there has to be traffic on the backend service.

## Clean up

```bash
kubectl delete -f .
```
