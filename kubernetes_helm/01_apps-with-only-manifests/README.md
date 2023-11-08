# Create the applications

## Manifests

Check the manifests with `tree` command

## Create the blue app on Development environment

```bash
kubectl create -f dev/blue
```

Check the status of the pods and see the blue pod running: 
```bash
kubectl get pods -n dev
```

Afterwards, you can visit the app via 
```bash
export ENDPOINT=$(gcloud compute addresses list --filter="region:europe-west3" --filter="name=training-kh-addr" --format="get(address)")

curl http://${ENDPOINT}/dev/blue
```

or via [ACCESS BLUE](http://${ENDPOINT}/dev/blue)

## Create the red app on Development environment

```bash
kubectl create -f dev/red
```

Check the status of the pods and see the red and blue pods running: 

```bash
kubectl get pods -n dev
```

Afterwards, you can visit the app via 

```bash
curl http://${ENDPOINT}/dev/red
```

or via [ACCESS RED](http://${ENDPOINT}/dev/red)

## Create the blue app on Production

```bash
kubectl create -f prod/blue
```

Check the status of the pods and see 3 blue pods running: 

```bash
kubectl get pods -n prod
```

Afterwards, you can visit the app via 

```bash
curl http://${ENDPOINT}/prod/blue
```

or via [ACCESS BLUE](http://${ENDPOINT}/prod/blue)

## Create the red app on Production

```bash
kubectl create -f prod/red
```

Check the status of the pods and see 3 red and 3 blue pods running: 

```bash
kubectl get pods -n prod
```

Afterwards, you can visit the app via 

```bash
curl http://${ENDPOINT}/prod/red
```

or via [ACCESS RED](http://${ENDPOINT}/prod/red)

## How long will it take to make a green app on both environments?

## Cleanup
* Delete the created resources
  ```bash
  kubectl delete -f dev/**,prod/**
  ```

Jump > [Home](../README.md) | Previous > [Cluster Setup](../00_setup/README.md) | Next > [Deploy with Kustomize](02_deploy-with-kustomize/README.md)