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

<!-- TODO change to avoiding latest -->
kubectl apply -f 10_kyverno/disallow-latest-tag.yaml
kubectl delete pod my-suboptimal-pod 
kubectl apply -f pod.yaml
=> expect error
```

