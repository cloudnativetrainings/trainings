# includes

{{- define "labels" -}}
helm.sh/chart: {{ .Chart.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/name: {{ .Chart.Name | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

adapt labels and selectors

helm install includes ./my-chart --dry-run > dry-run.yaml

helm install includes ./my-chart 

kubectl get all

curl $ENDPOINT

helm uninstall includes
