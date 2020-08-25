# Deployment

## Inspect and create the [deployment yaml file](./deployment-v1.yaml) 

```bash
kubectl create -f deployment.yaml
```

## Add another terminal and watch the Pods

```bash
watch -n 1 kubectl get pods
```

## Scale the number of replicas to 1 and take a look at the second terminal

```bash
kubectl scale deployment my-deployment --replicas 3
```

## Change the image of the deployment and take a look at the second terminal

```bash
kubectl set image deployment my-deployment nginx=nginx:1.19.1
```

## Inspect and re-create the [deployment yaml file](./deployment-v2.yaml) 

Pay attention to the deleted rollout strategy. Now Kubernetes defaults to the `rollingUpdate` rollout strategy.

```bash
kubectl apply -f deployment.yaml
```

## Change the image of the deployment and take a look at the second terminal

```bash
kubectl set image deployment my-deployment nginx=nginx:1.19.1
```

## Take a look at the replicasets

```bash
kubectl get replicasets
```

## Cleanup

```bash
kubectl delete deployment my-deployment
```
