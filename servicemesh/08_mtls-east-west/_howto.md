1. apply the yaml files

curl -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST/mtls
kubectl exec -it <FRONTEND-POD> -c frontend -- curl backend:8080/mtls
istioctl dashboard kiali - check security display settings
istioctl x authz check <BACKEND-POD>.training

change peerauthentication and apply

curl -H "Host: backend.training.svc.cluster.local" $INGRESS_HOST/mtls
kubectl exec -it <FRONTEND-POD> -c frontend -- curl backend:8080/mtls
istioctl dashboard kiali - check security display settings
istioctl x authz check <BACKEND-POD>.training
