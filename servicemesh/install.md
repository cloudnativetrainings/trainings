https://istio.io/latest/docs/setup/getting-started/

# Initial Setup
Kubernetes: 1.14.10-gke.41
Istio

istioctl profile list
istioctl manifest apply --set profile=demo
istioctl manifest generate --set profile=demo > generated-manifest.yaml
istioctl verify-install -f generated-manifest.yaml
kubectl get pod -n istio-system

# UI
istioctl dashboard kiali - credentials admin/admin
istioctl dashboard prometheus

# envoy injection
kubectl label namespace default istio-injection=enabled