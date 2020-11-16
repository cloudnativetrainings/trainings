# Circuit Breaker

In this lab you will configure a circuit breaker.

## Inspect and create the resources

```bash
kubectl create -f .
```

## Curl the api 

```bash
curl -i $INGRESS_HOST/api
```

## Set the api unavailable

```bash
curl $INGRESS_HOST/set_available/false
curl -i $INGRESS_HOST/api
```

## Take a look at the log files of the `backend` container. 

Note that there are more than one requests to the api.

## Curl the api and note the different response

```bash
curl -i $INGRESS_HOST/api
```

## Wait a minute

The CircuitBreaker is in closed state again and curl the api again

```bash
curl -i $INGRESS_HOST/api
```

## Clean up
```bash
kubectl delete -f .
```
