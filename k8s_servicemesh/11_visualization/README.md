# Visualization

## Inspect and create the resources

```bash
kubectl create -f .
```

## Make calls to the cat api. If you do not want to miss a cute cat click the link you get in the response.

```bash
while true; do curl -H "Host: frontend.training.svc.cluster.local" $INGRESS_HOST/cats; sleep 10; done;
```

## Make Prometheus available 

By default the Prometheus is of type ClusterIP. Let's change this. Change the service type from `ClusterIP` to `LoadBalancer` and set the `port` and the `nodePort` in the http port both to 30001 like this:

```bash
kubectl -n istio-system edit svc prometheus 
```

```yaml
spec:
  ...
  ports:
  - name: http
    nodePort: 30001
    port: 30001
  ...
  type: LoadBalancer
```

Get the LoadBalancer IP of Kiali and access it via the Browser via `http://<KIALI-EXTERNAL-IP>:30000`

## Make grafana available 

Change the type from ClusterIP to LoadBalancer and set the port to the same as the NodePort Port

## Make jaeger available (the service is called tracing) 

Change the type from ClusterIP to LoadBalancer and set the port to the same as the NodePort Port

## Play around with those tools

## Clean up

```bash
kubectl delete -f .
```
