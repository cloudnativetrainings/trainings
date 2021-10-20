# Required

In this task, you will learn how to use the required flag.

## Adapt the Deployment to the following

```yaml
...
containers:
   - name: my-nginx
     image: nginx:{{ required "A nginx version is required!" .Values.tag }}
...
```

## Release the application

Note that you will get an error message.
```bash
helm install required ./my-chart 
```

Try again with the tag provided.
```bash
helm install required ./my-chart --set tag=1.19.2
```

Access the endpoint via 
```bash
curl $ENDPOINT
```

## Cleanup

```bash
helm uninstall required
```

Jump > [Home](../README.md) | Previous > [If Statement](../07_ifs/README.md) | Next > [Testing](../09_tests/README.md)