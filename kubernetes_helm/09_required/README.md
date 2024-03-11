# Using the 'required' Function

In this task, you will learn how to use the 'required' function.

> Navigate to the directory `$HOME/trainings/kubernetes_helm/09_required`, before getting started.

## Adapt the Deployment to the following

Edit `./my-chart/templates/deployment.yaml` file:
```yaml
...
containers:
   - name: my-nginx
     image: nginx:{{ required "A nginx version is required!" .Values.tag }}
...
```

## Release the application

> Note that you will get an error message.
```bash
helm install required ./my-chart 
```

Try again with the tag provided.
```bash
helm install required ./my-chart --set tag=1.19.2
```

Wait until the pods are ready

```bash
kubectl wait pod -l app.kubernetes.io/instance=required --for=condition=ready --timeout=120s
```

Access the endpoint via 
```bash
curl $ENDPOINT
```

## Cleanup

```bash
# delete the resources
helm uninstall required

# jump back to home directory `kubernetes_helm`:
cd -
```
