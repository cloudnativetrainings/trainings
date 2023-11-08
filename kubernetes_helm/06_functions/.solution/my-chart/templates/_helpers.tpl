{{- define "id" }}
{{- $name := printf "%s-%s" .Chart.Name .Release.Name }}
{{- default $name .Values.id | trunc 63 }}
{{- end }}