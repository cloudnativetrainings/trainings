# Create the applications

## Manifests

Check the manifests:

```bash
cd $HOME/trainings/kubernetes_helm/01_apps-with-only-manifests

tree .
```

## Create the blue app on Development environment

```bash
kubectl create ns dev
kubectl create -f dev/blue
```

Check the status of the pods and see the blue pod running: 
```bash
kubectl get pods -n dev
```

Afterwards, you can visit the app via curl or your browser
```bash
# if $ENDPOINT is not defined, you can set it:
# export ENDPOINT=$(gcloud compute addresses list --filter="region:europe-west3" --filter="name=training-kh-addr" --format="get(address)")
# or
# kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath={.status.loadBalancer.ingress[].ip}

curl http://${ENDPOINT}/dev/blue
```

## Create the red app on Development environment

```bash
kubectl create -f dev/red
```

Check the status of the pods and see the red and blue pods running: 

```bash
kubectl get pods -n dev
```

Afterwards, you can visit the app via curl or your browser

```bash
curl http://${ENDPOINT}/dev/red
```

## Create the blue app on Production

```bash
kubectl create ns prod
kubectl create -f prod/blue
```

Check the status of the pods and see 3 blue pods running: 

```bash
kubectl get pods -n prod
```

Afterwards, you can visit the app via curl or your browser

```bash
curl http://${ENDPOINT}/prod/blue
```

## Create the red app on Production

```bash
kubectl create -f prod/red
```

Check the status of the pods and see 3 red and 3 blue pods running: 

```bash
kubectl get pods -n prod
```

Afterwards, you can visit the app via curl or your browser

```bash
curl http://${ENDPOINT}/prod/red
```

## How long will it take to make a green app on both environments?

## Cleanup

```bash
# delete the created resources
kubectl delete -f dev/**,prod/**
```
