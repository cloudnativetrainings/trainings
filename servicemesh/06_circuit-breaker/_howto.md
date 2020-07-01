1. apply the yaml files

curl $INGRESS_HOST/api
curl $INGRESS_HOST/set_available/false

uncomment the cb section in destinationrule and apply

check the logfiles

curl $INGRESS_HOST/api


--- 

first attempt fails but got answer from app
no respones afterwards - CB is in open state due to 3 failing requests (check logs)
after 1 minute the CB goes into closed state again
