# Testing

In this task, you will learn how to test your Chart.

## Inspect the application

## Run the test

```bash
helm install my-app ./my-app 
```

```bash
helm test my-app
```

```bash
helm uninstall my-app
```

## Verify failing test

Adapt the url in the test to something faulty.

```bash
helm install my-app ./my-app 
```

```bash
helm test my-app
```

Check the logfile of the test
```bash
kubectl logs my-app-test-<TAB>
```

## Cleanup

```bash
helm uninstall my-app
kubectl delete job my-app-test
```

Jump > [Home](../README.md) | Previous > [Required](../08_required/README.md) | Next > [Hooks](../10_hooks/README.md)