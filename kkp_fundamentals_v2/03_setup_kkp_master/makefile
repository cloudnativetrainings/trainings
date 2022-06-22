DNS_ZONE=$(shell gcloud dns managed-zones list --format json | jq '.[].name' | tr -d \")
DOMAIN=$(DNS_ZONE).loodse.training
IP=35.246.171.166

.PHONY: create_dns_records
create_dns_records: 
# TODO make a safeguard that ip is set
# PASS it into target - make foo=bar target
	gcloud dns record-sets transaction start --zone=$(DNS_ZONE)
	gcloud dns record-sets transaction add --zone=$(DNS_ZONE) --ttl 60 --name="$(DOMAIN)." --type A $(IP)
	gcloud dns record-sets transaction add --zone=$(DNS_ZONE) --ttl 60 --name="*.$(DOMAIN)."  --type A $(IP)
	gcloud dns record-sets transaction execute --zone $(DNS_ZONE)

