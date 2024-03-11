# Using the 'include' Function

In this task, you will make use of include' function.

> Navigate to the directory `$HOME/trainings/kubernetes_helm/07_includes`, before getting started

## Implement the labels function

Add the following function called `labels` into the file `_helpers.tpl` in the folder `my-chart/templates`

```bash
cat <<EOF >> my-chart/templates/_helpers.tpl

{{- define "labels" -}}
helm.sh/chart: {{ .Chart.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/name: {{ .Chart.Name | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}
EOF
```

## Make use of the `labels` function in your template files

Take care of the right indent, eg `{{- include "labels" . | nindent 2 }}`.

For example, edit `my-chart/templates/deployment.yaml` and add labels to the metadata:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ template "id" . }}
  labels:
    {{- include "labels" . | nindent 2 }}
spec:
  replicas: 1
...
```

You can dry-run the installation:

```bash
helm install includes ./my-chart --dry-run
```

You can check how the manifests look and verify if the indentation is correct with `helm template` command:

```bash
helm template ./my-chart
```

## Release the application

```bash
helm install includes --set id=includes ./my-chart 
```

Wait until the pods are ready

```bash
kubectl wait pod -l app=includes --for=condition=ready --timeout=120s
```

Access the endpoint via 
```bash
curl http://$ENDPOINT
```

## Cleanup

```bash
# delete the resources
helm uninstall includes

# jump back to home directory `kubernetes_helm`:
cd -
```
