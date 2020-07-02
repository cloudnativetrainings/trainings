# Hello K8s

In this course we will create an application which will be reachable in the WWW.

***NOTE:*** On GCP you may have to open the firewall with the default node-port range of Kubernetes - see [setup_cluster.sh to add firewall rule](../../setup_cluster.sh) or use the Service type `LoadBalancer`.

## 1. Create and expose an nginx application

```bash
## create the application
kubectl run my-nginx --image nginx --port 80

## expose the application
kubectl expose pod my-nginx --type NodePort
```

## 2. Access the application

```bash
## get the external IP address of the node
kubectl get nodes -o wide

## get the port of the application
kubectl get services

## curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>:<PORT>
```

## 3. Change the application

```bash
## exec into the container
kubectl exec -it <POD-NAME> bash

## install VIM in the container
apt update && apt install vim -y

## change content of the file `/usr/share/nginx/html/index.html` in the container
vi /usr/share/nginx/html/index.html

## exit the container
exit

## curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>:<PORT>
```

## 4. Cleanup the application

```bash
kubectl delete pod,svc my-nginx
```

## 5. Speed up CLI handling

Enable `kubectl` auto completion.

```bash
echo 'source <(kubectl completion bash)' >> ~/.bashrc && source ~/.bashrc
```
