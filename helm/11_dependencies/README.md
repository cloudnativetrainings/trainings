
check charts

helm dependency list ./my-app 

helm dependency update ./my-app

check charts directory and Chart.lock file

take a look at the condition of the dependency and the values.yaml

helm install app my-app 
kubectl exec -it my-app -- /bin/sh
curl my-dependency

helm uninstall app
helm install app my-app --set my-dependency.enabled=true
kubectl exec -it my-app -- /bin/sh
curl my-dependency

helm uninstall app
helm install app my-app --set my-dependency.enabled=true --set my-dependency.content="Bonjour Helm"
kubectl exec -it my-app -- /bin/sh
curl my-dependency
