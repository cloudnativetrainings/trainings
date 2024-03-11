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

### Cleanup

```bash
# delete the release
helm uninstall my-app
```

## Add the function called `id`

### Implement the function

Create a file with the name `_helpers.tpl` in the folder `my-chart/templates` and copy the following content into it.

```tpl
{{- define "id" }}
{{- printf "%s-%s" .Chart.Name .Release.Name }}
{{- end }}
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

>Note the output now gets calculated via the `id` function defined in the file `_helpers.tpl`. The expected output is `my-chart-helper-functions`

## Cleanup

```bash
# delete the resources
helm uninstall helper-functions

# jump back to home directory `kubernetes_helm`:
cd -
```
