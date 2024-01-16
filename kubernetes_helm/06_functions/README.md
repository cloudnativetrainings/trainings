# Functions

In this task, you will learn how to implement helper functions.

## Run the Helm Chart

```bash
cd $HOME/trainings/kubernetes_helm/06_functions
helm install my-app ./my-chart
```

Wait until the pods are ready

```bash
kubectl wait pod -l app=my-chart-my-app --for=condition=ready --timeout=120s
```

Access the endpoint via 
```bash
curl http://$ENDPOINT
```

## Cleanup
* Delete the release
  ```bash
  helm uninstall my-app
  ```

## Add the function called `id`

### Implement the function

Put the following function into the file `_helpers.tpl` in the folder `my-chart/templates`

```bash
cat <<EOF > my-chart/templates/_helpers.tpl
{{- define "id" }}
{{- printf "%s-%s" .Chart.Name .Release.Name }}
{{- end }}
EOF
```

### Make use of the `id` function

Replace all occurancies in the directory `my-chart/templates` of `{{ .Chart.Name }}-{{ .Release.Name }}` with `{{ template "id" . }}`

```bash
sed -i 's/{{ .Chart.Name }}-{{ .Release.Name }}/{{ template "id" . }}/g' ./my-chart/templates/*
```

### Release the application

```bash
helm install helper-functions ./my-chart 
```

Wait until the pods are ready

```bash
kubectl wait pod -l app=my-chart-helper-functions --for=condition=ready --timeout=120s
```

Access the endpoint via 
```bash
curl http://$ENDPOINT
```

### Cleanup
* Delete the release
  ```bash
  helm uninstall helper-functions
  ```

## Using default values

### Re-implement the function

Override the `id` function the file `_helpers.tpl` in the folder `my-chart/templates`

```bash
cat <<EOF > my-chart/templates/_helpers.tpl
{{- define "id" }}
{{- \$name := printf "%s-%s" .Chart.Name .Release.Name }}
{{- default \$name .Values.id | trunc 6 }}
{{- end }}
EOF
```

### Release the application

```bash
helm install default-values --set id=foo-123456 ./my-chart 
```

Wait until the pods are ready

```bash
kubectl wait pod -l app=foo-12 --for=condition=ready --timeout=120s
```

Access the endpoint via 
```bash
curl http://$ENDPOINT
```

### Cleanup
* Delete the release
  ```bash
  helm uninstall default-values
  ```
* Jump back to home directory `kubernetes_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > [Variables](../05_variables/README.md) | Next > ['include' Function](../07_includes/README.md)
