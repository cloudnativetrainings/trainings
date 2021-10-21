# Using the 'required' Function

In this task, you will learn how to use the 'required' function.

> Navigate to the directory `08_required`, before getting started.

## Adapt the Deployment to the following

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

Access the endpoint via 
```bash
curl $ENDPOINT
```

## Cleanup
* Delete the release
  ```bash
  helm uninstall required
  ```
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > [If Statement](../07_ifs/README.md) | Next > [Helm Test](../09_tests/README.md)