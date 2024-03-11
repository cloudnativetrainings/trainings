# Helm Test

In this task, you will learn how to test your Chart.

> Navigate to the directory `$HOME/trainings/kubernetes_helm/10_tests`, before getting started.

## Inspect the application

See the chart files. This one includes a test directory:

```bash
tree .
```

## Inspect the test

A Kubernetes Job to check ir the App responses successfully:

```bash
cat ./my-app/templates/tests/test-my-app.yaml
```

## Run the test

### Relase the app

```bash
helm install my-app ./my-app 
```

### Wait until the pods are ready

```bash
kubectl wait pod -l app=my-app --for=condition=ready --timeout=120s
```

### Run the test

```bash
helm test my-app
```

## Verify failing test

### Add a bug in the templates

```yaml
apiVersion: v1
kind: Service
metadata:
  name: wrong-service-name
...
```

### Release the chart again

```bash
helm upgrade my-app ./my-app/
```

### Wait until the pods are ready

```bash
kubectl wait pod -l app=my-app --for=condition=ready --timeout=120s
```

### Test the release

```bash
helm test my-app
```

> Note that the test is failing due to the service is not reachable from the curl command of the test.

### Check the logfile of the test

```bash
kubectl logs -l job-name=my-app-test
```

## Cleanup

```bash
# delete the resources
helm uninstall my-app
kubectl delete job my-app-test

# jump back to home directory `kubernetes_helm`:
cd -
```
