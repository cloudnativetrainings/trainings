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

```bash
istioctl dashbaord kiali
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.


## Make grafana available 

Change the type from ClusterIP to LoadBalancer and set the port to the same as the NodePort Port

## Make jaeger available (the service is called tracing) 

Change the type from ClusterIP to LoadBalancer and set the port to the same as the NodePort Port

## Play around with those tools

## Clean up

```bash
kubectl delete -f .
```
