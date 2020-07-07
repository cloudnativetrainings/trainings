# Ingress

In this training we will setup an Ingress.

## 1. Create the Application "red"

```bash
## Create a Deployment
kubectl run red --image nginx --port 80

## Expose the Deployment
kubectl expose deployment red
```

## 2. Change the content of index.html

Create the file `red.html` and copy it as `/usr/share/nginx/html/index.html` in your Pod.

```bash
echo '<!DOCTYPE html><html><body style="background-color:red;"></body></html>' > red.html
kubectl cp red.html <POD-NAME>:/usr/share/nginx/html/index.html
```

## 3. Create the Application "blue"

```bash
## Create a Deployment
kubectl run blue --image nginx --port 80

## Expose the Deployment
kubectl expose deployment blue
```

## 4. Change the content of index.html

Create the file `blue.html` and copy it as `/usr/share/nginx/html/index.html` in your Pod.

```bash
echo '<!DOCTYPE html><html><body style="background-color:blue;"></body></html>' > blue.html
kubectl cp blue.html <POD-NAME>:/usr/share/nginx/html/index.html
```

## 5. Verify your steps

```bash
kubectl get deployments,pods,svc
```

## 6. Create a Namespace for the Ingress resources

```bash
kubectl create ns ingress
```

## 7. Create the RBAC resources and the Ingress controller

Copy of [https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md](https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md).

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ingress-service-account
  namespace: ingress
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: ingress-cluster-role-binding
  namespace: ingress
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: ingress-service-account
    namespace: ingress
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ingress-controller
  namespace: ingress
  labels:
    app: ingress-controller
spec:
  selector:
    matchLabels:
      app: ingress-controller
  template:
    metadata:
      labels:
        app: ingress-controller
    spec:
      serviceAccountName: ingress-service-account
      terminationGracePeriodSeconds: 10
      containers:
        - name: ingress-controller
          image: gcr.io/google_containers/nginx-ingress-controller:0.9.0-beta.15
          readinessProbe:
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
          livenessProbe:
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
            initialDelaySeconds: 10
            timeoutSeconds: 1
          ports:
            - hostPort: 80
              containerPort: 80
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          args:
            - /nginx-ingress-controller
            - --default-backend-service=kube-system/default-http-backend
            - --ingress-class=nginx
            - --v=2
```

Apply it to your cluster.

```bash
kubectl create -f controller.yaml
```

## 9. Verify everything is running

```bash
kubectl -n ingress get ds,pods
```

## 10. Create the LoadBalancer to enable external traffic to the Ingress

```yaml
apiVersion: v1
kind: Service
metadata:
  namespace: ingress
  name: loadbalancer
  labels:
    app: loadbalancer
spec:
  type: LoadBalancer
  ports:
    - port: 80
      name: http
      targetPort: 80
  selector:
    app: ingress-controller
```

Apply it to your cluster.

```bash
kubectl create -f loadbalancer.yaml
```

## 11. Wait until you get an external IP address

```bash
kubectl -n ingress get svc
```

## 12. Create your Ingress route

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  namespace: default
  name: ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    ingress.kubernetes.io/ssl-redirect: "false"
    ingress.kubernetes.io/rewrite-target: "/"
spec:
  rules:
  - http:
      paths:
      - path: /red
        backend:
          serviceName: red
          servicePort: 80
      - path: /blue
        backend:
          serviceName: blue
          servicePort: 80
```

Apply it to your cluster.

```bash
kubectl create -f ingress.yaml
```

## 13. Verify your steps

```bash
kubectl describe ing ingress
```

## 14. Visit the applications "red" and "blue" in your browser via

* `http://<EXTERNAL-IP>/red`
* `http://<EXTERNAL-IP>/blue`

## 15. Clean up

```bash
kubectl delete ns ingress
kubectl delete deployment,svc --all
```
