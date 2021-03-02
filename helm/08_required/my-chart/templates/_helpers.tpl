{{- define "id" }}
{{- $name := printf "%s-%s" .Chart.Name .Release.Name }}
{{- default $name .Values.id | trunc 63 }}
{{- end }}

{{- define "labels" -}}
helm.sh/chart: {{ .Chart.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/name: {{ .Chart.Name | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}