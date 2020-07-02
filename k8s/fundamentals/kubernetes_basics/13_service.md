# Services

***NOTE:*** On GCP you may have to open the firewall with the default node-port range of Kubernetes - see [kubernetes_cluster/01_gke-create-cluster.md#allow-nodeport-range](../kubernetes_cluster/01_gke-create-cluster.md#allow-nodeport-range)

## 1. Create a Deployment

```bash
kubectl create deployment --image nginx --dry-run nginx -o yaml > deployment.yaml
cat deployment.yaml

kubectl apply -f deployment.yaml
kubectl get deployment,pod
```

## 2. Create the yaml configuration for the Service via the following command

```bash
kubectl create service nodeport --tcp 80:80 --dry-run nginx -o yaml > service.yaml
```

## 3. Inspect the created file

```bash
## retrieve information about service specifications
kubectl explain service.spec

## check a service label
cat service.yaml
kubectl apply -f service.yaml
```

## 4. Take a look at the created Endpoints and IPs of the Pods

```bash
kubectl get po,ep -o wide
```

## 5. Scale up the deployment

```bash
kubectl scale deployment nginx --replicas 3
```

## 6. Take a look at the created Endpoints and IPs of the Pods

```bash
kubectl get pod,endpoints -o wide
```

## 7. Test accessing your service

Access the application over the service will load balance your request to one IP of the endpoints.

```bash
## get the external IP address of the node
kubectl get nodes -o wide

## get the port of the application
kubectl get services

## curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>:<PORT>
```

## 8. To access the traffic from a public stable IP

Change your service to type `LoadBalancer`

```bash
## edit your yaml definition, modify type to 'type: LoadBalancer'
vim service.yaml

## update the service object
kubectl apply -f service.yaml

## get the external IP and the port of the application
## be aware that external LoadBalancer could maybe take a while
## to get provisioned
kubectl get services

## curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>
```

## 9. Clean up

```bash
kubectl delete svc,deploy nginx
```
