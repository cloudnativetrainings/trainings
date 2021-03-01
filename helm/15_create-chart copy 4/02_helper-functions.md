
# create file _heplers.tpl
```
{{- define "id" }}
{{- printf "%s-%s" .Chart.Name .Release.Name }}
{{- end }}
```

# use function
replace
{{ .Chart.Name }}-{{ .Release.Name }}
with
{{ template "id" . }}

helm install helper-functions ./my-chart 

kubectl get all

curl $ENDPOINT

helm uninstall helper-functions
