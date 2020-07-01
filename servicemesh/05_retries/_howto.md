1. apply the yaml files

curl $INGRESS_HOST/api
curl $INGRESS_HOST/set_delay/10

uncomment the timeout in the virtualservice and apply change

second terminal: kubectl logs -f backend-XXX backend

curl $INGRESS_HOST/api

check the logfiles

first attempt
3 retries afterwards
timeout after 8 seconds