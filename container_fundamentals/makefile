VM_NAME = container-fundamentals
ZONE = europe-west3-a
PROJECT_ID = $(shell gcloud projects list --format json | jq .[].name | tr -d \")

.PHONY: create
create:

	# set project in google cloud shell
	gcloud config set project $(PROJECT_ID) 
	echo gcloud config set project $(PROJECT_ID) >> ~/.bashrc

	# create resources
	gcloud compute firewall-rules create you-are-welcome \
		--direction=INGRESS --priority=1000 --network=default \
		--action=ALLOW --rules=all --source-ranges=0.0.0.0/0
	gcloud compute instances create $(VM_NAME) --zone=$(ZONE) \
		--machine-type=n2-standard-2 \
		--image-family=ubuntu-2204-lts \
		--image-project=ubuntu-os-cloud \
		--boot-disk-size=200GB \
		--metadata-from-file user-data=cloudinit.yaml

.PHONY: connect
connect:
	gcloud compute ssh root@$(VM_NAME) --zone=$(ZONE) 

.PHONY: get-external-ip-from-cloud-shell
get-external-ip-from-cloud-shell:
	gcloud compute instances list --format json | jq '.[].networkInterfaces[].accessConfigs[].natIP' | tr -d \"

.PHONY: get-external-ip
get-external-ip:
	curl https://wtfismyip.com/text

.PHONY: destroy
destroy:
	gcloud compute firewall-rules delete you-are-welcome --quiet
	gcloud compute instances delete $(VM_NAME) --zone=$(ZONE) --quiet