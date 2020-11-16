
# Routing via percent

In this training you will learn how to route some traffic towards different versions of an application.

## Build, dockerize and push frontend:2.0.0 image

```bash
cd 00_apps
vi ./build_frontend.sh   # set the VERSION from 1.0.0 to 2.0.0
./build_frontend.sh
```

## Verify the images exist in the container registry via the UI

## Apply the yaml files

```bash
kubectl create -f .
```

## Curl the application

Verify that ~ 90 % of the requests are from Version 2.0.0

```bash
while true; do curl $INGRESS_HOST; sleep 1; done;
```

## Change the percentage in the VirtualService to eg 50 % per version and apply the changes

```bash
vi frontend-virtualservice.yaml
kubectl apply -f frontend-virtualservice.yaml
```

## Curl the application

Verify the change you made

```bash
while true; do curl $INGRESS_HOST; sleep 1; done;
```

## Clean up

```bash
kubectl delete -f .
```


