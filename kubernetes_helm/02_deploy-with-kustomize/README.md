# Kustomize Configuration

## Inspect the Layout

```bash
cd $HOME/trainings/kubernetes_helm/02_deploy-with-kustomize
tree .
```

You will see that, there are 2 directories: base and overlay. Under overlay, there is dev and prod, which are configured to deploy on different namespaces on the cluster.

## Inspect base kustomization.yaml

```bash
batcat base/kustomization.yaml
```

- Add label app=demo to all the resources created.
- Include manifests for deployment, service, and ingress

## Inspect dev overlay kustomization.yaml

```bash
batcat overlays/dev/kustomization.yaml
```

- Get all resources from base
- Add environment=dev label to all resources created
- Add namespace=dev to all resources created
- Patch ingress to change the URL path
- Generate a ConfigMap for the index.html
- Patch deployment to use a different NGINX image

## Inspect prod overlay kustomization.yaml

```bash
batcat overlays/prod/kustomization.yaml
```

- Get all resource from and and configmap.yaml from the current directory
- Add environment=prod label to all resources created
- Annotate all resources created with managed-by=kustomize
- Add namespace=prod to all resources created
- Patch deployment to have 3 replicas
- Patch ingress to change the URL path
- Patch deployment to use different Pod resources

# Deploy using Kustomize

## Deploy dev

First, inspect the generated manifest:

```bash
kustomize build overlays/dev
```

You can have 2 options to deploy:

1. Kustomize CLI:
```bash
kustomize build overlays/dev | kubectl apply -f -
```

2. Kubectl:
```bash
kubectl apply -k overlays/dev
```

Checkout the pods and verify that the application is running:

```bash
# Wait until the pod is ready:
kubectl get pods -n dev
```

Access the page via curl or your browser: 
```bash
# export ENDPOINT=$(gcloud compute addresses list --filter="region:europe-west3" --filter="name=training-kh-addr" --format="get(address)")

curl http://${ENDPOINT}/dev
```

## Deploy prod

First, inspect the generated manifest:

```bash
kustomize build overlays/prod
```

Deploy:

```bash
kubectl apply -k overlays/prod
```

Checkout the pods and verify that the application is running. There must be 3 pods running.

```bash
# Wait until the pod is ready:
kubectl get pods -n prod
```

```bash
curl http://${ENDPOINT}/prod
```


# Cleanup

* Delete the deployments:

```bash
kubectl delete -k overlays/dev

kubectl delete -k overlays/prod
```

Jump > [Home](../README.md) | Previous > [Apps with Only Manifests](../01_apps-with-only-manifests/README.md) | Next > [Deploy with Helm](../03_apps-with-helm/README.md)