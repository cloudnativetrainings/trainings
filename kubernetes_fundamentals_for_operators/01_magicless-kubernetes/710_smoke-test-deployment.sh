#!/bin/bash

export KUBECONFIG=secrets/admin.kubeconfig

kubectl run nginx --image=nginx
sleep 3
kubectl get pods -l run=nginx -o wide

echo ""
echo "-----------POD running ?-------------------"
echo ""

POD_NAME=$(kubectl get pods -l run=nginx -o jsonpath="{.items[0].metadata.name}")
kubectl wait --for=condition=Ready pod/$POD_NAME

kubectl port-forward $POD_NAME 8080:80 &

echo ""
echo "-----------POD reachable ?------------------"
echo ""

sleep 5
curl --head http://127.0.0.1:8080

kill %1

echo ""
echo "-----------POD logs ?------------------"
echo ""

kubectl logs $POD_NAME --tail=10

###conitinue with exec
# https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/13-smoke-test.md#exec

exit 0
