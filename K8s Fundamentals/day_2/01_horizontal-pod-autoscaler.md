# Horizontal Pod Autoscaler

***NOTE:*** On GCP you may have to open the firewall with the default node-port range of Kubernetes - see [setup_cluster.sh to add firewall rule](../../setup_cluster.sh) or use the Service type `LoadBalancer`.

## 1. Create and expose an application

```bash
kubectl create deployment my-deployment --image nginx
kubectl create service nodeport --tcp 80:80 my-deployment
```

## 2. Create an Horizontal Pod Autoscaler

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: my-autoscaler
spec:
  maxReplicas: 5
  minReplicas: 1
  scaleTargetRef:
    apiVersion: extensions/v1beta1
    kind: Deployment
    name: my-deployment
  targetCPUUtilizationPercentage: 1
```

Apply it to the cluster.

```bash
kubectl create -f hpa.yaml
```

## 3. Take a look at the resource consumption of your nodes and your pods

```bash
kubectl top nodes
kubectl top pods
```

## 4. Get the IP and Port for your Service

```bash
kubectl get nodes,services -o wide
```

## 5. Open a new terminal and put on some load on your application

```bash
while true; do curl <EXTERNAL-IP>:<SERVICE-PORT>; done;
```

## 6. Take a look at the number of pods which will get created

```bash
watch -n 1 kubectl top pods
```

## 7. Clean up

```bash
kubectl delete deploy,svc my-deployment
kubectl delete hpa my-autoscaler
```
