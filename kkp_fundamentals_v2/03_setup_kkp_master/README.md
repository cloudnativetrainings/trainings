export KUBECONFIG=~/master/kubeone/master-kubeconfig

# increase worker nodes
kubectl -n kube-system scale md master-pool1 --replicas 3

# change URLs

gcloud dns managed-zones list --format json | jq '.[].dnsName' | tr -d \"
<!-- TODO remove last dot -->

=> replace cluster.example.dev via url in values.yaml and kubermatic.yaml

# DEX

SECRETS 

`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32`

create random secret in values.yaml

kubermatic.yaml - auth / issuerclientsecret 
has to match
values - dex / cleints / kubermaticIssuer / secret

## static passwords

htpasswd -bnBC 10 "" PASSWORD_HERE | tr -d ':\n' | sed 's/$2y/$2a/'

(password)

email: student-00.kkp-admin-training@loodse.training

# telemetry

uuidgen -r

# clusterissuer
=> change email address
kubectl apply -f clusterissuer.yaml


# install kkp

kubermatic-installer --charts-directory ./charts deploy --config kubermatic.yaml --helm-values values.yaml --storageclass gce

# DNS
student-00-kkp-admin-training.loodse.training.      IN  A  35.246.171.166
*.student-00-kkp-admin-training.loodse.training.    IN  A  35.246.171.166

make create_dns_records

gcloud dns record-sets list --zone $DNS_ZONE
nslookup $SUBDOMAIN.$TLD

dig NS $SUBDOMAIN.$TLDpwd

# verify in browser

visit url

=> not secure

# switch to letsencrypt-prod

change letsencrypt-staging to letsencrypt-pod in values.yaml and kubermatic.yaml

kubermatic-installer --charts-directory ./charts deploy --config kubermatic.yaml --helm-values values.yaml --storageclass gce

kubectl get certs -A

=> wait and hope


Delete related TLS Secret
Delete related CertiificateRequest
Delete related Certificate
restart the cert-manager pod