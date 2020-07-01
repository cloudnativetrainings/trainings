1. apply the yaml files

curl $INGRESS_HOST/api
curl $INGRESS_HOST/set_delay/10
curl $INGRESS_HOST/api

uncomment the timeout in the virtualservice

curl $INGRESS_HOST/api
