.PHONY: create
create:
	gcloud compute firewall-rules create you-are-welcome \
		--direction=INGRESS --priority=1000 --network=default \
		--action=ALLOW --rules=all --source-ranges=0.0.0.0/0
	gcloud compute instances create kubernetes-security \
  		--zone=europe-west3-a \
  		--machine-type=n2-standard-2 \
  		--image-family=ubuntu-2204-lts \
  		--image-project=ubuntu-os-cloud \
  		--metadata-from-file user-data=cloudinit.yaml
destroy:
        gcloud compute instances delete kubernetes-security \
                --zone=europe-west3-a \
                --delete-disks=all \
                --quiet
        gcloud compute firewall-rules delete you-are-welcome --quite