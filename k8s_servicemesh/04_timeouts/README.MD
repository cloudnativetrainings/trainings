# Timeouts

In this task you will configure a timeout.

## Inspect and create the resources

```bash
kubectl create -f .
```

## Curl the api 

```bash
curl $INGRESS_HOST/api
```

## Set the delay of the api to 10 seconds

```bash
curl $INGRESS_HOST/set_delay/10
```

## Curl the api 

Note the latency of the response

```bash
curl $INGRESS_HOST/api
```

## Uncomment the timeout in the VirtualService and apply the change

```bash
vi backend-virtualservice.yaml
kubectl apply -f backend-virtualservice.yaml
```

## Curl the api 

Note that we get a timeout response

```bash
curl $INGRESS_HOST/api
```

## Clean up

```bash
curl $INGRESS_HOST/set_delay/0
kubectl delete -f .
```
