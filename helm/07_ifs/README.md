# Ifs

In this task you will make use of an if statement.

## Adapt the Configmap to the following

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ template "id" . }}
data:
  body: |
    {{- if not .Values.meta }}
    Hello Helm
    {{- else }}
    Chart: {{ .Chart.Name }}
    Description: {{ .Chart.Description }}
    Version: {{ .Chart.Version }}
    AppVersion: {{ .Chart.AppVersion }}
    Release: {{ .Release.Name }}
    Release.Namespace : {{ .Release.Namespace }}
    Release.IsUpgrade : {{ .Release.IsUpgrade }}
    Release.IsInstall : {{ .Release.IsInstall }}
    Release.Revision : {{ .Release.Revision }}
    Release.Service : {{ .Release.Service }}
    {{- end }}
```

## Release the application

```bash
helm install ifs ./my-chart --set meta=true
```

Access the endpoint via 
```bash
curl $ENDPOINT
```

## Cleanup

```bash
helm uninstall ifs
```
