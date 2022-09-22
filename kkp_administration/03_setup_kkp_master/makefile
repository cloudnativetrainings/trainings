.PHONY: create_dns_records
create_dns_records: 
	gcloud dns record-sets transaction start --zone=$(DNS_ZONE)
	gcloud dns record-sets transaction add --zone=$(DNS_ZONE) --ttl 60 --name="$(DOMAIN)." --type A $(IP)
	gcloud dns record-sets transaction add --zone=$(DNS_ZONE) --ttl 60 --name="*.$(DOMAIN)."  --type A $(IP)
	gcloud dns record-sets transaction execute --zone $(DNS_ZONE)
