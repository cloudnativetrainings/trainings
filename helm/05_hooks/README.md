
check application

check hooks

helm install hooks ./my-app 

check hookds

helm uninstall my-app

check hooks

kubectl delete job --all

---

# weight

add additional pre-install hook

add annotations properly
    "helm.sh/hook-weight": "2"

helm install hooks ./my-app 

helm uninstall my-app

kubectl delete job --all

---

# kill hooks

add annotation
    "helm.sh/hook-delete-policy": hook-succeeded

helm install hooks ./my-app 

helm uninstall my-app

kubectl get pods,jobs



---

# Notes
helm uninstall hooks --no-hooks

