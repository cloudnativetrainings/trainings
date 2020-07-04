# Setup instructions

## cd into the servicemesh folder
```bash
cd /k8s-exercises/servicemesh/scripts
```

## fix the container registry path
1. adapt the PROJECT_NAME in the file `01_fix_repo_location.sh`
```bash
vi 01_fix_repo_location.sh
```
2. execute the shell script
```bash
./01_fix_repo_location.sh
```

## create the k8s cluster
1. adapt the PROJECT_NAME in the file `02_setup_cluster.sh`
```bash
vi 02_setup_cluster.sh
```
2. execute the shell script
```bash
./02_setup_cluster.sh
```
3. verify installation
```bash
kubectl get nodes
```
4. install bash completion
```bash
source <(kubectl completion bash)
```

## install istioctl
1. execute the shell script
```bash
./03_setup_istio.sh
```
2. verify installation
```bash
istioctl version
```

## install istio to kubernetes cluster
1. start the installer
```bash
istioctl install --set profile=demo 
```
2. verify installation
```bash
istioctl verify-install
```
3. set the $INGRESS_HOST
```bash
export INGRESS_HOST=$(kubectl -n istio-system  get service istio-ingressgateway -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
```
4. verify the $INGRESS_HOST
```bash
echo $INGRESS_HOST
```

## create the `training` namespace
1. apply the yaml file
```bash
cd ..
kubectl apply -f 00_namespace
```
2. switch to the `training` namespace
```bash
kubens training
```


## create the application images
1. build, dockerize and push the images
```bash
cd 00_backend
./build.sh
cd ../00_frontend
./build.sh
cd ..
```
2. verify the images exist in the container registry via the UI
