
explain application

explain metadata

show object name variables

helm install meta-data ./my-chart

kubectl get all

export ENDPOINT=$(kubectl get svc traefik-ingress-service -o jsonpath="{.status.loadBalancer.ingress[0].ip}") 

curl $ENDPOINT

helm uninstall meta-data


