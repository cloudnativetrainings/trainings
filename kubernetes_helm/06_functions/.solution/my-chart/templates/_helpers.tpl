{{- define "id" }}
{{- printf "%s-%s" .Chart.Name .Release.Name }}
{{- end }}