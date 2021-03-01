# use templating functions

{{- define "id" }}
{{- $name := printf "%s-%s" .Chart.Name .Release.Name }}
{{- default $name .Values.id | trunc 63 }}
{{- end }}

https://helm.sh/docs/chart_template_guide/function_list/

helm install templating-functions --set id=foo ./my-chart 

kubectl get all

curl $ENDPOINT

helm unintstall templating-functions


