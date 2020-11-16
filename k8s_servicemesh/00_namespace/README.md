# Create the `training` namespace

## Create our training namespace in which istio injection is enabled

```bash
kubectl create -f ./namespace.yaml
```

## Switch to the namespace `training`

```bash
kubens training
```
