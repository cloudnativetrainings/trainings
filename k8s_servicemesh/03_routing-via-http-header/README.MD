# Routing via HTTP header

In this training we will setup routing based on a HTTP header.

## Inspect and create the resources

```bash
kubectl create -f .
```

## Make a request for user bob

Verify that the response comes from frontend in version 1.0.0

```bash
curl -H "user: bob" $INGRESS_HOST
```

## Make an anonymous request

Verify that the response comes from frontend in version 2.0.0

```bash
curl $INGRESS_HOST
```

## Clean up

```bash
kubectl delete -f .
```
