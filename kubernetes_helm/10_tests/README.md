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
batcat ./my-app/templates/tests/test-my-app.yaml
```

## Run the test

Relase the app:
```bash
helm install my-app ./my-app 
```

Wait until the pods are ready
```bash
kubectl wait pod -l app=my-app --for=condition=ready --timeout=120s
```

Run the test:
```bash
helm test my-app
```

Cleanup the release:
```bash
helm uninstall my-app
```

## Verify failing test

Adapt the URL in the test to something faulty and release:
```bash
sed -i 's/:80/-xx:80/' ./my-app/templates/tests/test-my-app.yaml
helm install my-app ./my-app
```

Wait until the pods are ready
```bash
kubectl wait pod -l app=my-app --for=condition=ready --timeout=120s
```

Test the release
```bash
helm test my-app
```

Check the logfile of the test
```bash
kubectl logs -l job-name=my-app-test
```

## Cleanup
* Delete the release and resources
  ```bash
  helm uninstall my-app
  kubectl delete job my-app-test
  ```
* Jump back to home directory `kubernetes_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > ['required' Function](../09_required/README.md) | Next > [Hooks](../11_hooks/README.md)