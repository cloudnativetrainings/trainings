# Setup addons

## Navigate to project folder to insatll addons
```bash
cd 00_install_addons
```

## Prometheus

```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/prometheus.yaml
```

## Grafana

```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/grafana.yaml
```

## Kiali

Note, due to CRDs, you have to apply this yaml file twice.

```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/kiali.yaml
```

## Jaeger

```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/jaeger.yaml
```
