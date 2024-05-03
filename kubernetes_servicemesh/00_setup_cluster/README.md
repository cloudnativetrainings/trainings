# Setup training environment

## Navigate to project folder to create cluster first
```bash
cd 00_setup_cluster
```

## Fix the repo url in the yaml files

```bash
./fix_repo_location.sh
```

## Create the cluster

```bash
./setup_cluster.sh
. <(kubectl completion bash)
kubectl get nodes
```

## Install istioctl

```bash
./install_istioctl.sh
istioctl version
```

## Install istio into your cluster
```bash
istioctl install --set profile=demo
```
