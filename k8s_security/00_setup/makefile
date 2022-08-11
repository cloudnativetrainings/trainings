# include /home/hubert/Desktop/academy/secrets/env.sh

# IMAGE_REPOSITORY = ueber
# APPLICATION_NAME = campus-backend
# BUILD_VERSION = 0.0.5

.PHONY: create
create:
	gcloud compute instances create hubert-cloud-init-test \
  		--zone=europe-west3-a \
  		--machine-type=n2-standard-2 \
  		--image-family=ubuntu-2204-lts \
  		--image-project=ubuntu-os-cloud \
  		--metadata-from-file user-data=cloudinit.yaml

# .PHONY: connect
# connect: export LOD_IP=$$(hcloud server list -o noheader -o columns=ipv4)
# connect: export LOD_SSH_KEY_PATH=/home/hubert/git/lines-of-defence/secrets/id_rsa
# connect:
# 	ssh-keygen -f "/home/hubert/.ssh/known_hosts" -R "$(LOD_IP)"
# 	ssh -o StrictHostKeyChecking=no -i $(LOD_SSH_KEY_PATH) root@$(LOD_IP)

# .PHONY: delete
# delete: export LOD_ID=$$(hcloud server list -o noheader -o columns=id)
# delete:
# 	hcloud server delete $(LOD_ID)
