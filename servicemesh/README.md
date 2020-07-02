# Setup instructions

## Clone the git repo
```bash
git clone https://github.com/loodse/k8s-exercises.git
```

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

## create the `training` namespace
```bash
cd ..
kubectl apply -f 00_namespace
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
