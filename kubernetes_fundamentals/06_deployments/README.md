# Deployment

In the training, we will learn about Deployment.

>Navigate to the folder `06_deployments` from CLI, before you get started. 

## Recreate rollout strategy

* Inspect deployment-v1.yaml definition file and create the deployment
  ```bash
  cat deployment-v1.yaml
  kubectl create -f deployment-v1.yaml
  ```

* Open second terminal to watch the Pods
  ```bash
  watch -n 1 kubectl get pods
  ```

* Scale the number of replicas to 3 and take a look at the second terminal
  ```bash
  kubectl scale deployment my-deployment --replicas 3
  ```

* Change the image of the deployment and take a look at the second terminal
  ```bash
  kubectl set image deployment my-deployment nginx=nginx:1.19.1
  ```

## RollingUpdate rollout strategy

* Inspect and re-create the deployment
  >Pay attention to the deleted rollout strategy. Now Kubernetes defaults to the `rollingUpdate` rollout strategy.
  ```bash
  kubectl replace --force -f deployment-v2.yaml
  ```

* Change the image of the deployment and take a look at the second terminal
  ```bash
  kubectl set image deployment my-deployment nginx=nginx:1.19.1
  ```

* Take a look at the deployment and replicasets
  ```bash
  kubectl get deploy,rs
  ```

## Cleanup
Delete the Deployment
```bash
kubectl delete deployment my-deployment
```
Verify if deployment is delete including all the associated pods and replicasets
```bash
kubectl get deploy,rs,po
```


[Jump to Home](../README.md) | [Previous Training](../05_replicasets/README.md) | [Next Training](../07_revision-history/README.md)