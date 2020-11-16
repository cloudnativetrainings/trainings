# Mutual TLS

## Inspect and create the resources

```bash
kubectl create -f .
```

## Curl the api and note the client cert header

```bash
curl -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST/mtls
```

Note an output like this verifies tls communication
```
mtls request - client cert header By=spiffe://cluster.local/ns/training/sa/default;Hash=7a27fff898812a54990ae99edd24346880a7c1614cf031077139f68ca571d0a9;Subject="";URI=spiffe://cluster.local/ns/istio-system/sa/istio-ingressgateway-service-account
```

## Curl the api from the `frontend` container and note the client cert header

```bash
kubectl exec -it <FRONTEND-POD> -c frontend -- curl backend:8080/mtls
```

Note an output like this verifies tls communication
```
mtls request - client cert header By=spiffe://cluster.local/ns/training/sa/default;Hash=7a27fff898812a54990ae99edd24346880a7c1614cf031077139f68ca571d0a9;Subject="";URI=spiffe://cluster.local/ns/istio-system/sa/istio-ingressgateway-service-account
```

## Install Kiali



kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/kiali.yaml

TBD twice due to CRDs

 change the type from ClusterIP to LoadBalancer and set the port to the same as the NodePort Port

kubectl -n istio-system edit svc kiali 

kubectl delete -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/kiali.yaml


## Verify TLS with kiali. Use the External-IP of the kiali and the NodePort. Check the Graph and enable the Security Display Setting. Note that there has to be traffic on the backend service.

## Verify TLS via istioctl

```bash
istioctl x authz check <BACKEND-POD>.training
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

## Verify TLS via istioctl

```bash
istioctl x authz check <BACKEND-POD>.training
```

## Clean up

```bash
kubectl delete -f .
```
