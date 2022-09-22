# Visualization

## Inspect and create the resources

```bash
kubectl create -f .
```

## Make calls to the cat api. If you do not want to miss a cute cat click the link you get in the response.

```bash
while true; do curl -H "Host: frontend.training.svc.cluster.local" $INGRESS_HOST/cats; sleep 10; done;
```

## Make Kiali available 

```bash
istioctl dashboard kiali
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.

## Make Prometheus available 

```bash
istioctl dashboard prometheus
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.

## Make grafana available 

```bash
istioctl dashboard grafana
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.

## Make jaeger available 

```bash
istioctl dashboard jaeger
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.

## Clean up

```bash
kubectl delete -f .
```
