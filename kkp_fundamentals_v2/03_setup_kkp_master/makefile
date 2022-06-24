DNS_ZONE=$(shell gcloud dns managed-zones list --format json | jq '.[].name' | tr -d \")
DOMAIN=$(DNS_ZONE).loodse.training

.PHONY: create_dns_records
create_dns_records: 
# TODO make a safeguard that ip variable is set
	gcloud dns record-sets transaction start --zone=$(DNS_ZONE)
	gcloud dns record-sets transaction add --zone=$(DNS_ZONE) --ttl 60 --name="$(DOMAIN)." --type A $(IP)
	gcloud dns record-sets transaction add --zone=$(DNS_ZONE) --ttl 60 --name="*.$(DOMAIN)."  --type A $(IP)
	gcloud dns record-sets transaction execute --zone $(DNS_ZONE)

