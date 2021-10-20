# Services

In the training, we will learn about Services.

>Navigate to the folder `08_services` from CLI, before you get started. 

## Create and expose the application

* Inspect deployment.yaml definition file and create the pod
  ```bash
  cat deployment.yaml
  kubectl create -f deployment.yaml
  ```

* Inspect service-v1.yaml definition file and create the service
  ```bash
  cat service-v1.yaml
  kubectl create -f service-v1.yaml
  ```

* Take a look at the created endpoints and IPs of the pods
  ```bash
  kubectl get po,ep -o wide
  ```

## Scale up the deployment
* Scale the deployment 
  ```bash
  kubectl scale deployment my-deployment --replicas 3
  ```

* Take a look at the created Endpoints and IPs of the pods
  ```bash
  kubectl get po,ep -o wide
  ```

## Access a ClusterIP Service
* Port forward the service port 80 to the local port 8080
  ```bash
  kubectl port-forward service/my-service 8080:80
  ```

*  You can now access the service (in a seperate terminal)
  ```bash
  curl http://127.0.0.1:8080
  ```

* You can stop the port-forwarding process via <CTRL>+<C>

## Access a NodePort Service

* Inspect service-v2.yaml definition file and apply the changes to the service
  ```bash
  cat service-v2.yaml
  kubectl apply -f service-v2.yaml
  ```

* Access the service
  
  Get an EXTERNAL-IP of one of the nodes
  ```bash
  kubectl get nodes -o wide
  ```
  You can now access the service (or via web browser)
  ```bash
  curl http://<EXTERNAL-IP>:30000
  ```

## Access a LoadBalancer Service

* Inspect service-v3.yaml definition file and apply the changes to the service
  ```bash
  cat service-v3.yaml
  kubectl apply -f service-v3.yaml
  ```

* Access the service
  
  Get an EXTERNAL-IP of the service
  ```bash
  kubectl get svc 
  ```
  You can now access the service (or via web browser)
  ```bash
  curl http://<EXTERNAL-IP>
  ```

## Cleanup
* Delete the resources - deployment and service.
  ```bash
  kubectl delete deploy my-deployment
  kubectl delete svc my-service
  ```

[Jump to Home](../README.md) | [Previous Training](../07_revision-history/README.md) | [Next Training](../09_configmaps/README.md)