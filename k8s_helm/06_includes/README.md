# Using the 'include' Function

In this task, you will make use of include' function.

> Navigate to the directory `06_includes`, before getting started

## Implement the labels function

Add the following function called `labels` into the file `_helpers.tpl` in the folder `my-chart/templates`

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
* Delete the release
  ```bash
  helm uninstall includes
  ```
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > [Functions](../05_functions/README.md) | Next > [If Statement](../07_ifs/README.md)