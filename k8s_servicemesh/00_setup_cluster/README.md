# Setup training environment

## Fix the repo url in the yaml files

```bash
./fix_repo_location.sh
```

## Create the cluster

```bash
./setup_cluster.sh
```

## Install istioctl

```bash
./install_istioctl.sh
```

## Install istio into your cluster
```bash
istioctl install --set profile=demo
```
