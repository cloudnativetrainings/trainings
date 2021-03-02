# Using includes

In this task you will make use of includes.

## Implement the labels function

Add the following function into the file `_helpers.tpl` in the folder `my-chart/templates`

```tpl
{{- define "labels" -}}
helm.sh/chart: {{ .Chart.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/name: {{ .Chart.Name | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}
```

## Make use of the `labels` function in your template files

Take care of the right indent, eg `{{- include "labels" . | nindent 6 }}`.

## Release the application

```bash
helm install includes --set id=includes ./my-chart 
```

Access the endpoint via 
```bash
curl $ENDPOINT
```

## Cleanup

```bash
helm uninstall includes
```
