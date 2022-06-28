
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

kubectl apply -f ~/master/kkp/storageclass-fast.yaml

# install kkp

kubermatic-installer --charts-directory ~/master/kkp/charts deploy --config ~/master/kkp/kubermatic.yaml --helm-values ~/master/kkp/values.yaml 

# clusterissuer
=> change email address
kubectl apply -f ~/master/kkp/clusterissuer.yaml

# DNS
student-00-kkp-admin-training.loodse.training.      IN  A  35.246.171.166
*.student-00-kkp-admin-training.loodse.training.    IN  A  35.246.171.166

make IP=35.198.157.140 create_dns_records

gcloud dns record-sets list --zone student-00-kkp-admin-training
nslookup student-00-kkp-admin-training.loodse.training
nslookup test.student-00-kkp-admin-training.loodse.training

dig NS $SUBDOMAIN.$TLDpwd

# verify in browser

visit url

=> not secure

# switch to letsencrypt-prod

change letsencrypt-staging to letsencrypt-pod in values.yaml and kubermatic.yaml

<!-- TODO abs paths everywhere -->
kubermatic-installer deploy \
    --config ~/master/kkp/kubermatic.yaml \
    --helm-values ~/master/kkp/values.yaml \
    --charts-directory ~/master/kkp/charts

kubectl get certs -A

=> wait and hope


