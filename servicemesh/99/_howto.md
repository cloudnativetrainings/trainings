apply the yaml files

curl

curl -H "Host: frontend.loodse.training" $URL
curl
curl -H "Host: backend.loodse.training" $URL
set timeout interval
curl -H "Host: backend.loodse.training" $URL/set_timeout/10
trigger frontend-backend communication
curl -H "Host: frontend.loodse.training" $URL/call_backend_timeout