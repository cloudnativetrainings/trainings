.PHONY: create_seed_dns_record
create_seed_dns_record: 
	gcloud dns record-sets transaction start --zone=$(GCP_DNS_ZONE)
	gcloud dns record-sets transaction add --zone=$(GCP_DNS_ZONE) --ttl 60 --name="*.kubermatic.$(GCP_DOMAIN)." --type A $(IP)
	gcloud dns record-sets transaction execute --zone $(GCP_DNS_ZONE)

.PHONY: teardown
teardown: 
# TODO
# gcloud dns record-sets transaction start --zone=$(GCP_DNS_ZONE)
# gcloud dns record-sets transaction remove --zone=$(GCP_DNS_ZONE) --type A $(IP) --name="*.kubermatic.$(GCP_DOMAIN)." 
# gcloud dns record-sets transaction execute --zone $(GCP_DNS_ZONE)
