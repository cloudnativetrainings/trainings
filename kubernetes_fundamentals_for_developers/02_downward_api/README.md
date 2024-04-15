# Downward API

In this training, you will learn about downward API to provide a container some information about itself.

Change into the lab directory:

```bash
cd $HOME/trainings/kubernetes_application_development/03_downward_api
```

## How it works

Check the pod spec:

```bash
cat k8s/pod.yaml
```

Apply the manifests and check the result through the ingress:

```bash
kubectl apply -f k8s/

# Get the environment values
curl http://${INGRESS_IP}/my-app/downward_api
```

Also, check the `downwardAPI` volume:

```bash
# Check annotations
kubectl exec -it my-app -- cat /etc/podinfo/annotations

# Check labels
kubectl exec -it my-app -- cat /etc/podinfo/labels
```

## Cleanup

```bash
kubectl delete -f k8s/
```

<!--  TODO move this to slides  -->

## Available Fields

### Both as Environment Variable and downwardAPI volume

| Field  | Description   |
|--------|---------------|
| `metadata.name` | the pod's name |
| `metadata.namespace` | the pod's namespace |
| `metadata.uid` |the pod's unique ID |
| `metadata.annotations['<KEY>']` | the value of the pod's annotation named <KEY> (for example, `metadata.annotations['myannotation']`) |
| `metadata.labels['<KEY>']` | the text value of the pod's label named <KEY> (for example, `metadata.labels['mylabel']` |

### Only as Environment Variable

| Field  | Description   |
|--------|---------------|
| `spec.serviceAccountName` |the name of the pod's service account |
| `spec.nodeName` |the name of the node where the Pod is executing |
| `status.hostIP` |the primary IP address of the node to which the Pod is assigned |
| `status.hostIPs` |the IP addresses is a dual-stack version of `status.hostIP`, the first is always the same as `status.hostIP`. The field is available if you enable the PodHostIPs feature gate. |
| `status.podIP` | the pod's primary IP address (usually, its IPv4 address) |
| `status.podIPs` | the IP addresses is a dual-stack version of `status.podIP`, the first is always the same as `status.podIP` |

### Only as `downwardAPI` volume

| Field  | Description   |
|--------|---------------|
| `metadata.labels` | all of the pod's labels, formatted as `label-key="escaped-label-value"` with one label per line |
| `metadata.annotations` | all of the pod's annotations, formatted as `annotation-key="escaped-annotation-value"` with one annotation per line |
