1. apply the yaml files

curl -v -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST

uncomment the abort section
curl -v -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST
=> check the 500 response codes

comment the abort section and uncomment the delay section
curl -v -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST
=> check the delays

fiddle around with the percentages
