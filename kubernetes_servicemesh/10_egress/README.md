# Egress Traffic

## Inspect and create the resources

```bash
kubectl create -f .
```

## Allow all outbound traffic 

This is the default setting in Istio.

### Curl via the `backend` container. 

Note that you get a vaild response. You can reach servers outside your cluster.

```bash
kubectl exec -it <BACKEND-POD> backend -- curl https://www.google.com
```

### Verify the call to the external service in Kiali

```bash
istioctl dashboard kiali
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.

Note that the node called PassthroughCluster appears.

## Disallow all outbound traffic 

Run istioctl with the following flag.

```bash
istioctl install --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY
```

You can verify your setting via the following. Note that the field `outboundTrafficPolicy.mode` has to be `REGISTRY_ONLY`

```bash
kubectl -n istio-system  get cm istio -o jsonpath="{.data.mesh}"
```

### Curl via the `backend` container. 

Note that you do not get a vaild response. You cannot reach servers outside your cluster.

```bash
kubectl exec -it <BACKEND-POD> backend -- curl https://www.google.com
```

### Verify the call to the external service in Kiali

```bash
istioctl dashboard kiali
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.

Note that the node called BlackHoleCluster appears.

### Create the `google-serviceentry.yaml` file and apply it to the cluster

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: google
spec:
  hosts:
    - www.google.com
  ports:
    - number: 443
      name: https
      protocol: HTTPS
  resolution: DNS
  location: MESH_EXTERNAL
```

```bash
kubectl create -f google-serviceentry.yaml
```

### Curl via the `backend` container

Note that you get a valid response.

```bash
kubectl exec -it <BACKEND-POD> backend -- curl https://www.google.com
```

## Verify the call to the external service in Kiali

```bash
istioctl dashboard kiali
```

Use the feature `Web Preview` of Google Cloud Shell. You have to change the port.

Note that the node called `google` appears.

## Clean up

```bash
kubectl delete -f .
```
