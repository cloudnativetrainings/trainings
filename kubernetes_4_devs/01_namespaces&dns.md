# Namespaces & DNS
In this course we will try to communicate between namespaces.

1. For easy namespace switching we will make use of kubens. Please install it like this
```bash
git clone https://github.com/ahmetb/kubectx.git
sudo cp kubectx/kubens /usr/local/bin/
```
2. Create two namespaces
```bash
kubectl create ns red
kubectl create ns blue
```
3. Switcht to the namespcae `red`
```bash
kubens red
```
4. Create and expose an nginx server
```bash
kubectl run --generator run-pod/v1 bob --image nginx --port 80 --labels app=bob
kubectl expose pod bob
```
5. Create another Pod, install curl and make a request to the first pod
```bash
# run a Pod
kubectl run --generator run-pod/v1 alice --rm -it --image debian -- bash
# install curl
apt update && apt install curl -y
# curl the first Pod
curl bob
```
6. Switch to the namespaces called `blue`
```bash
kubens blue
```
7. Create another Pod, install curl and make a request to the first pod
```bash
# run a Pod
kubectl run --generator run-pod/v1 alice --rm -it --image debian -- bash
# install curl
apt update && apt install curl -y
# curl the first Pod - this will not work
curl bob
# curl the first Pod again with the namespace postfix added - this will work
curl bob.red
# curl the first Pod again with the full DNS name - this will work
curl bob.red.svc.cluster.local
```