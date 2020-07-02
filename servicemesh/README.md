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

## install istio
1. adapt the PROJECT_NAME in the file `02_setup_cluster.sh`
```bash
vi 02_setup_cluster.sh
```
2. execute the shell script
```bash
./02_setup_cluster.sh
```
03_setup_istio.sh