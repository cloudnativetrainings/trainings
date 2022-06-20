# loodse-training-infrastructure

gcloud dns managed-zones list

<!-- ENV -->
export DNS_ZONE=loodse-training
export TLD=loodse.training
export SUBDOMAIN=hubert-test-monday
export IP=112.112.112.113

gcloud dns record-sets transaction start --zone=$DNS_ZONE
gcloud dns record-sets transaction add --zone=$DNS_ZONE --name="$SUBDOMAIN.$TLD." --ttl 300 --type A $IP
<!-- cat transaction.yaml -->
gcloud dns record-sets transaction execute --zone $DNS_ZONE

<!-- VERIFY -->
gcloud dns record-sets list --zone $DNS_ZONE
nslookup $SUBDOMAIN.$TLD


# student project

gcloud dns managed-zones list

<!-- ENV -->
export DNS_ZONE=student-00-kkp-admin-training
export TLD=loodse.training
export SUBDOMAIN=$DNS_ZONE
export IP=112.112.112.113

gcloud dns record-sets transaction start --zone=$DNS_ZONE
gcloud dns record-sets transaction add --zone=$DNS_ZONE --name="$SUBDOMAIN.$TLD." --ttl 300 --type A $IP
<!-- cat transaction.yaml -->
gcloud dns record-sets transaction execute --zone $DNS_ZONE

<!-- VERIFY -->
gcloud dns record-sets list --zone $DNS_ZONE
nslookup $SUBDOMAIN.$TLD

dig NS $SUBDOMAIN.$TLD