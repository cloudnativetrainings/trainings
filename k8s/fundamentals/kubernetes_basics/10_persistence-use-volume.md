# Using a Volume in a Pod

***NOTE:*** On GCP you may have to open the firewall with the default node-port range of Kubernetes - see [setup_cluster.sh to add firewall rule](../../setup_cluster.sh) or use the Service type `LoadBalancer`.

## 1. Create the following Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volume-example
spec:
  terminationGracePeriodSeconds: 1
  containers:
    - name: nginx
      image: nginx:stable-alpine
      ports:
        - containerPort: 80
      volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
          readOnly: true
    - name: content
      image: alpine:latest
      volumeMounts:
        - name: html
          mountPath: /html
      command: ["/bin/sh", "-c"]
      args:
        - while true; do
          echo $(date)"<br />" >> /html/index.html;
          sleep 5;
          done
  volumes:
    - name: pvc-storage-class-example
      persistentVolumeClaim:
        claimName: my-pvc
```

```bash
kubectl create -f pod.yaml
```

There is an issue with this structure. Try to fix the error and verify via `kubectl get po`. You are finished if you get a similar output like this:

```bash
kubectl get po
NAME             READY   STATUS    RESTARTS   AGE
volume-example   2/2     Running   0          3m52s
```

## 2. Expose the Pod

This command will fail.

```bash
$ kubectl expose pod volume-example --type NodePort
error: couldn't retrieve selectors via --selector flag or introspection: the pod has no labels and cannot be exposed
```

## 3. Label the Pod via the following command and expose the Pod afterwards

```bash
kubectl label pod volume-example app=volume-example
kubectl expose pod volume-example --type NodePort
```

## 4. Access the application

```bash
## get the external IP address of the node
kubectl get nodes -o wide

## get the port of the application
kubectl get services

## curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>:<PORT>
```

## 5. Delete the Pod

```bash
kubectl delete pod volume-example
```

## 6. Re-create the Pod andtake care about the proper labels

## 7. Verify if the output contains the timestamps from step 6

## 8. Clean up

```bash
kubectl delete po,svc volume-example
kubectl delete pv,pvc --all
```
