# GKE Master setup

Setup a GKE HA cluster:

Login to your [Google Cloud console](https://ssh.cloud.google.com/cloudshell/editor) or use the `gcloud` CLI tool locally.
```bash
gcloud auth login
``` 
```bash
./00_setup_cluster.sh
```

For later login to a cluster ue:
```bash
./10_login_cluster.sh
```

To destroy the cluster use:
```bash
20_delete_cluster.sh
```

## (If needed) cleanup namespaces

Please clean up deployments, ingress, and certmanager:
```bash
### if applied at the kubeone tutorial
#Delete the CustomResourceDefinitions and cert-manager itself
kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.yaml
### delete maybe some left over validation webhooks
kubectl delete -A ValidatingWebhookConfiguration --all

kubectl get ns
### delete every namespace, besides of default,kube-*
kubectl delete ns app
kubectl delete ns app-ext
kubectl delete ns cert-manager
kubectl delete ns ingress-nginx
```
**check all is clean!**
```
kubectl get ns
NAME              STATUS   AGE
default           Active   7h43m
kube-node-lease   Active   7h43m
kube-public       Active   7h43m
kube-system       Active   7h43m
```
Check also if some old CRDs are in place:
```
kubectl api-resources | grep cert
```
**only** `certificates.k8s.io` should be in the output
```
certificatesigningrequests        csr          certificates.k8s.io            false        CertificateSigningRequest***NOTE:*** if a namespace is in state pending for longer then a few minutes, you could use the cleanup script `kubermatic/helper-scripts/kill-kube-ns.sh`
```

## (If needed) cleanup DNS Entries

Delete entries `*.DNS_ZONE.loodse.training.` at [Google Cloud DNS](https://console.cloud.google.com/net-services/dns/zones/)
