# Hello K8s
In this course we will create an application which will be reachable in the WWW.

1. Create and expose an nginx application
```bash
# Create the application
kubectl run my-nginx --image nginx --port 80
# Expose the application
kubectl expose deployment my-nginx --type NodePort
```
2. Access the application
```bash
# Get the external IP address of the node
kubectl get nodes -o wide
# Get the port of the application
kubectl get services
# Curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>:<PORT>
```
3. Change the application
```bash
# Exec into the container
kubectl exec -it <POD-NAME> bash
# Install VIM in the container
apt update && apt install vim -y
# Change content of the file `/usr/share/nginx/html/index.html` in the container
vi /usr/share/nginx/html/index.html
# Exit the container
exit
# Curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>:<PORT>
```
4. Cleanup the application
```bash
kubectl delete deployment,svc my-nginx
```