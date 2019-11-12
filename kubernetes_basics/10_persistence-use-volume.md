# Using a Volume in a Pod

1. Create the following Pod. 
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
```
```bash
kubectl create -f pod.yaml
```
2. There is an issue with this structure. Try to fix the error and verify via `kubectl get po`. You are finished if you get a similar output like this:
```bash
kubectl get po
NAME             READY   STATUS    RESTARTS   AGE
volume-example   2/2     Running   0          3m52s
```
3. Expose the Pod. This command will fail.
```bash
kubectl expose pod volume-example --type NodePort
error: couldn't retrieve selectors via --selector flag or introspection: the pod has no labels and cannot be exposed
```
4. Label the Pod via the following command and expose the Pod afterwards
```bash
kubectl label pod volume-example app=volume-example
kubectl expose pod volume-example --type NodePort
```
5. Access the application
```bash
# Get the external IP address of the node
kubectl get nodes -o wide
# Get the port of the application
kubectl get services
# Curl the application (or visit it in your Browser)
curl http://<EXTERNAL-IP>:<PORT>
```
6. Delete the Pod via `kubectl delte pod volume-example`
7. Re-create the Pod, take care about the proper labels. 
8. Verify if the output contains the timestamps from step 7.
9. Clean up
```bash
kubectl delete po,svc volume-example
kubectl delete pv,pvc --all
```