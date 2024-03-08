# Hello K8s

In this course, we will create an application which will be reachable in the WWW.

>Navigate to the folder `01_hellow-k8s` from CLI, before you get started. 

## Create and expose the application

* Inspect pod.yaml definition file and create the pod
  ```bash
  cat pod.yaml
  kubectl create -f pod.yaml
  ```

* Inspect service.yaml file content and create the service
  ```bash
  cat service.yaml
  kubectl create -f service.yaml
  ```

## Access the application

* Print the service details
  ```bash
  kubectl get services
  ```
  >Copy the EXTERNAL-IP of your service

* Curl the application (or visit it in your Browser)
  ```bash
  curl http://<EXTERNAL-IP>
  ```

## Modify the application

* Copy the index.html file into the pod
  ```bash
  kubectl cp index.html my-pod:/usr/share/nginx/html/index.html
  ```

* Curl the application (or visit it in your Browser)
  ```bash
  curl http://<EXTERNAL-IP>
  ```

## Cleanup
* Delete the resources - pod and service.
  ```bash
  kubectl delete pod my-pod
  kubectl delete service my-service
  ```
