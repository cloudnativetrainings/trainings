# Functions

In this task you will learn how to implement helper functions.

## Run the Helm Chart

```bash
helm install my-app ./my-chart
```

Access the endpoint via 
```bash
curl $ENDPOINT
```

## Cleanup

Remove the release
```bash
helm uninstall my-app 
```

## Add the function called `id`

### Implement the function

Put the following function into the file `_helpers.tpl` in the folder `my-chart/templates`
```tpl
{{- define "id" }}
{{- printf "%s-%s" .Chart.Name .Release.Name }}
{{- end }}
```

### Make use of the `id` function

Replace all occurancies in the directory `my-chart/templates` of `{{ .Chart.Name }}-{{ .Release.Name }}` with `{{ template "id" . }}`

### Release the application

```bash
helm install helper-functions ./my-chart 
```

Access the endpoint via 
```bash
curl $ENDPOINT
```

### Cleanup

Remove the release
```bash
helm uninstall helper-functions
```

## Using default values

### Re-implement the function

Override the `id` function the file `_helpers.tpl` in the folder `my-chart/templates`
```tpl
{{- define "id" }}
{{- $name := printf "%s-%s" .Chart.Name .Release.Name }}
{{- default $name .Values.id | trunc 63 }}
{{- end }}
```

### Release the application

```bash
helm install default-values --set id=foo ./my-chart 
```

Access the endpoint via 
```bash
curl $ENDPOINT
```

### Cleanup

```bash
helm uninstall default-values
```

