.PHONY: create_seed_dns_record
create_seed_dns_record: 
	gcloud dns record-sets transaction start --zone=$(DNS_ZONE)
	gcloud dns record-sets transaction add --zone=$(DNS_ZONE) --ttl 60 --name="*.kubermatic.$(DOMAIN)." --type A $(IP)
	gcloud dns record-sets transaction execute --zone $(DNS_ZONE)
