# Ifs

In this task, you will make use of an if statement.

> Navigate to the directory `07_ifs`, before getting started.

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

## Upgrade the application

```bash
helm upgrade ifs ./my-chart --set meta=false
```

Watch the endpoint via
```bash
watch curl $ENDPOINT
```

## Cleanup
* Delete the release
  ```bash
  helm uninstall ifs
  ```
* Jump back to home directory `k8s_helm`:
  ```bash
  cd -
  ```

Jump > [Home](../README.md) | Previous > ['include' Function](../06_includes/README.md) | Next > ['required' Function](../08_required/README.md)