
# create nginx 
kubectl run my-nginx --port 80 --labels app=my-nginx --image nginx
kubectl expose pod my-pod --type NodePort

# verify in browser
kubectl get svc
curl $IP:30242

# check network policy

kubectl apply -f my-network-policy.yaml

kubectl run caller --rm -it --image nicolaka/netshoot

curl my-nginx
=> expected failure

kubectl run caller --rm -it --labels app=caller --image nicolaka/netshoot

curl my-nginx
=> should work