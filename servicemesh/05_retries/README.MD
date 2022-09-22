# Retries

In this task you will costumize the retries.

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

## Uncomment the `timeout` and the `retries` section of the VirtualService and apply the change

```bash
vi backend-virtualservice.yaml
kubectl apply -f backend-virtualservice.yaml
```

Open a second terminal and watch the logfiles of the backend container

```bash
# Second terminal
kubectl logs -f <BACKEND-POD> backend
```

## Curl the api 

Watch the logs in the second terminal 

```bash
# First terminal
curl $INGRESS_HOST/api
```

## Clean up

```bash
curl $INGRESS_HOST/set_delay/0
kubectl delete -f .
```
