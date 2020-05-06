# RBAC

1. Get the URL of the api-server
```bash
kubectl cluster-info
```
2. Try to curl the apiserver. This will not work due to permissions.
```bash
curl -s <API-SERVER-URL>/api/v1/namespaces/default/pods 
```
3. Take a look at the existing ServiceAccounts
```bash
kubectl get sa
```
4. Take a look at the existing ClusterRoles
```bash
kubectl get clusterroles
```
5. Take a look at the existing ClusterRoleBindings
```
kubectl get clusterrolebindings
```
6. Create a new ServiceAccount
```bash
kubectl create sa spy
```
7. Take a look at the ClusterRole `view`
```bash
kubectl describe clusterrole view
```
8. Bind the Role to the ServiceAccount
```bash
kubectl create rolebinding rbac --clusterrole=view --serviceaccount=default:spy
```
9. Get the name of the ServiceAccounts Secret
```bash
kubectl describe sa spy
```
10. Printout the secret
```bash
kubectl get secret <SECRET-NAME> -o yaml
```
11. Get the content of the field `ca.crt` and store it into a file
```bash
echo <CA-CRT-CONTENT> | base64 -d > ca.crt
```
12. Get the content of the field `token` and store it into a file and into an Variable
```bash
echo <TOKEN-CONTENT> | base64 -d > token
TOKEN=$(cat token)
```
13. Curl the api-server again.
```bash
curl -s <API-SERVER-URL>/api/v1/namespaces/default/pods --header "Authorization: Bearer $TOKEN" --cacert ca.crt
```
14. Create a Pod
```bash
apiVersion: v1
kind: Pod
metadata:
  name: spy
spec:
  serviceAccountName: spy
  containers:
    - name: spy
      image: debian
      command: [ "/bin/sh" ]
      args: [ "-c", "sleep 1h" ]
```
```bash
kubectl create -f pod.yaml
```
15. Exec into the Pod
```bash
kubectl exec -it spy -- bash
```
16. Compare the contents of the following files with the token and the ca.crt of the prev steps
* /var/run/secrets/kubernetes.io/serviceaccount/token
* /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
