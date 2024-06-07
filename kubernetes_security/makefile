
.PHONY: setup
setup:
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
	# verify installation
	containerd --version
	kubelet --version
	kubeadm version
	kubectl version
	# # verify env vars
    # test -n "$(IP)"
    # test -n "$(API_SERVER)"
    # test -n "$(ETCDCTL_API)"
    # test -n "$(ETCDCTL_ENDPOINTS)"
    # test -n "$(ETCDCTL_CACERT)"
    # test -n "$(ETCDCTL_KEY)"
    # test -n "$(ETCDCTL_CERT)"
	# TODO ceck node is in ready state (=CNI plugin)
	# TODO check metrics server
	# TODO check git repo is on its place
	helm version
	test -n "$(INGRESS_IP)"
	etcdctl version
	kubesec version
	trivy --version
	helm status -n kyverno kyverno
	systemctl is-active apparmor
	# TODO check gvisor
	# TODO check falco

.PHONY: teardown
teardown:
	gcloud compute instances delete kubernetes-security --zone europe-west3-a --quiet
	gcloud compute firewall-rules delete you-are-welcome --quiet
