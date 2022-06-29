
# change URLs

gcloud dns managed-zones list --format json | jq '.[].dnsName' | tr -d \"
<!-- TODO remove last dot -->

=> replace cluster.example.dev via url in values.yaml and kubermatic.yaml

# DEX

SECRETS 

cat /dev/urandom | tr -dc A-Za-z0-9 | head -c32

create random secret in values.yaml

kubermatic.yaml - auth / issuerclientsecret 
has to match
values - dex / cleints / kubermaticIssuer / secret

## static passwords

htpasswd -bnBC 10 "" password | tr -d ':\n' | sed 's/$2y/$2a/'

(password)

email: student-00.kkp-admin-training@loodse.training

# telemetry

uuidgen -r

# storageclass

kubectl apply -f ~/kkp/storageclass-fast.yaml

# install kkp

export KUBECONFIG=~/.kube/config

kubermatic-installer --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml

# clusterissuer
=> change email address
kubectl apply -f ~/kkp/clusterissuer.yaml

# DNS
student-00-kkp-admin-training.loodse.training.      IN  A  35.246.171.166
*.student-00-kkp-admin-training.loodse.training.    IN  A  35.246.171.166

make IP=34.159.160.52 create_dns_records

gcloud dns record-sets list --zone student-00-kkp-admin-training
<!-- TODO student-00 is not true for students -->
nslookup student-00-kkp-admin-training.loodse.training
nslookup test.student-00-kkp-admin-training.loodse.training

gcloud dns record-sets list --zone student-01-kkp-admin-training

dig NS $SUBDOMAIN.$TLD

# switch to letsencrypt-prod

change letsencrypt-staging to letsencrypt-pod in values.yaml and kubermatic.yaml
auth.skipTokenIssuerTLSVerify=false in kubermatic.yaml

kubermatic-installer --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml     

kubectl get certs -A

=> wait and hope

# verify in browser

visit url
