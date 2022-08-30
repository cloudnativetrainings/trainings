# Admission Control with Kyverno

## Verify Installation

```bash
# check if kyverno is installed on cluster level
helm list -n kyverno
```

## Apply a ClusterPolicy

```bash
# inspect the cluster policy
cat 10_kyverno/disallow-latest-tag.yaml

# apply the cluster policy
kubectl apply -f 10_kyverno/disallow-latest-tag.yaml

# delete the pod
kubectl delete pod my-suboptimal-pod 

# try to apply the pod - note you will get an error due to no image tag is provided
kubectl apply -f pod.yaml

# add the image tag to the image, eg `image: ubuntu:22.04`. Re-run the apply command. Now it works again
kubectl apply -f pod.yaml
```

