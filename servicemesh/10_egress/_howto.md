

apply yaml files

kubectl exec -it backend-1.0.0-847b5585b-2lqlb backend -- curl https://www.google.com
check kiali

kubectl -n istio-system  get cm istio -o yaml > 10_egress/istio-cm.yaml

change configmap
```yaml
    outboundTrafficPolicy:
      mode: REGISTRY_ONLY
```
# change takes some time
kubectl exec -it backend-1.0.0-847b5585b-2lqlb backend -- curl https://www.google.com
check kiali

apply google-servicenetry

kubectl exec -it backend-1.0.0-847b5585b-2lqlb backend -- curl https://www.google.com
check kiali


