.PHONY: create
create:
	gcloud compute firewall-rules create you-are-welcome \
		--direction=INGRESS --priority=1000 --network=default \
		--action=ALLOW --rules=all --source-ranges=0.0.0.0/0
	gcloud compute instances create kubernetes-security \
		--zone=europe-west3-a \
		--machine-type=n2-standard-4 \
		--image-family=ubuntu-2204-lts \
		--image-project=ubuntu-os-cloud \
		--boot-disk-size=100GB \
		--metadata-from-file user-data=cloudinit.yaml

.PHONY: verify
verify:
	containerd --version
	kubelet --version
	kubeadm version
	kubectl version
	# TODO ceck node is in ready state (=CNI plugin)
	# TODO check metrics server
	# TODO check git repo is on its place
	helm version
	etcdctl version
	kubesec version
	trivy --version
	# TODO check kyverno installed via helm script
	systemctl is-active apparmor
	# TODO check gvisor
	# TODO check falco


# # TODO
# verify steps
# falco failed
# gvisor install
