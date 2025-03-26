# Ifs

In this task, you will make use of an if statement.

> Navigate to the directory `$HOME/trainings/kubernetes_helm/08_ifs`, before getting started.

## Adapt the Configmap to the following

Update `./my-chart/templates/configmap.yaml` file as follows"

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ template "id" . }}
data:
  body: |
    {{- if not .Values.meta }}
    Hello Helm
    {{- else }}
    Chart: {{ .Chart.Name }}
    Description: {{ .Chart.Description }}
    Version: {{ .Chart.Version }}
    AppVersion: {{ .Chart.AppVersion }}
    Release: {{ .Release.Name }}
    Release.Namespace : {{ .Release.Namespace }}
    Release.IsUpgrade : {{ .Release.IsUpgrade }}
    Release.IsInstall : {{ .Release.IsInstall }}
    Release.Revision : {{ .Release.Revision }}
    Release.Service : {{ .Release.Service }}
    {{- end }}
```

## Release the application

```bash
helm install ifs ./my-chart --set meta=true
```

Wait until the pods are ready

```bash
kubectl wait pod -l  app.kubernetes.io/instance=ifs --for=condition=ready --timeout=120s
```

Access the endpoint via

```bash
curl http://$ENDPOINT
```

## Upgrade the application

```bash
helm upgrade ifs ./my-chart --set meta=false
```

Watch the endpoint via

```bash
watch curl -s http://$ENDPOINT
```

> Question:
> What triggered the pod restart after a ConfigMap change?

<details>

<summary>Answer</summary>

### deployment.yaml

This is a Kubernetes feature and you can use it with Helm like this:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ template "id" . }}
spec:
  replicas: 1
  selector:
    matchLabels: {{ - include "labels" . | nindent 6 }}
  template:
    metadata:
      labels: {{ - include "labels" . | nindent 8 }}
      annotations:
        ## Here is the magic!
        checksum/config:
          {
            {
              include (print $.Template.BasePath "/configmap.yaml") . | sha256sum,
            },
          }
    spec:
      containers:
        - name: my-nginx
          image: nginx:1.19.2
          volumeMounts:
            - name: html
              mountPath: /usr/share/nginx/html
          resources:
            requests:
              cpu: 100m
              memory: 100Mi
            limits:
              cpu: 100m
              memory: 100Mi
      volumes:
        - name: html
          configMap:
            name: {{ template "id" . }}
            items:
              - key: body
                path: index.html
```

</details>

## Check the HPA configuration

Check if any Horizantal Pod Autoscaler is installed:

```bash
kubectl get hpa
```

There is a `hpa.yaml` file in the templates, check it out:

```bash
cat my-chart/templates/hpa.yaml
```

So, it depends on the values. Check out the values.yaml:

```bash
cat my-chart/values.yaml
```

As you see, HPA is not enabled by default.

## Upgrade the release with HPA

Now, let's enable HPA:

```bash
helm upgrade ifs ./my-chart --set horizantalPodAutoscaler.enabled=true
```

Checkout if a HPA is created:

```bash
kubectl get hpa
```

## Cleanup

```bash
# delete the resources
helm uninstall ifs

# jump back to home directory `kubernetes_helm`:
cd -
```
