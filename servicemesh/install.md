https://istio.io/latest/docs/setup/getting-started/

# Initial Setup
Kubernetes: 1.14.10-gke.41
Istio

istioctl profile list
istioctl manifest apply --set profile=demo
istioctl manifest generate --set profile=demo > generated-manifest.yaml
istioctl verify-install -f generated-manifest.yaml
kubectl get pod -n istio-system

## bash
export $INGRESS_IP=${kubectl -n istio-system  get service istio-ingressgateway -o jsonpath="{.status.loadBalancer.ingress[0].ip}"}

## fish
export INGRESS_HOST=(kubectl -n istio-system  get service istio-ingressgateway -o jsonpath="{.status.loadBalancer.ingress[0].ip}")


# UI
istioctl dashboard kiali - credentials admin/admin
istioctl dashboard prometheus

# envoy injection
kubectl label namespace default istio-injection=enabled

-----

# newest version

GKE 1.16.9-gke.6
istio 1.6.3

istioctl install --set profile=demo
istioctl verify-install




