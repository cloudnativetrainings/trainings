.PHONY: install_k1
install_k1:
	curl -L https://github.com/kubermatic/kubeone/releases/download/v$(KUBEONE_VERSION)/kubeone_$(KUBEONE_VERSION)_linux_amd64.zip --output ~/.tmp/kubeone-$(KUBEONE_VERSION).zip
	mkdir -p ~/.tmp/kubeone-$(KUBEONE_VERSION)
	rm -rf ~/.tmp/kubeone-$(KUBEONE_VERSION)/*
	unzip ~/.tmp/kubeone-$(KUBEONE_VERSION).zip -d ~/.tmp/kubeone-$(KUBEONE_VERSION)
	chmod +x ~/.tmp/kubeone-$(KUBEONE_VERSION)/kubeone
	sudo cp ~/.tmp/kubeone-$(KUBEONE_VERSION)/kubeone ~/bin

.PHONY: setup_k1_folder
setup_k1_folder:
	cp -r ~/.tmp/kubeone-$(KUBEONE_VERSION)/examples/terraform/gce/* ~/kubeone
	sed -i 's/GCP_PROJECT/$(GCP_PROJECT_ID)/g' ~/kubeone/terraform.tfvars
	# added to make worker nodes preemptible
	sed -i 's/\(preemptible *=\).*/\1 true/' ~/kubeone/output.tf

.PHONY: terraform
terraform:
	cd ~/kubeone; terraform init
	cd ~/kubeone; terraform apply -var=control_plane_target_pool_members_count=1 -auto-approve
	cd ~/kubeone; terraform output -json > tf.json

.PHONY: create_cluster
create_cluster:
	cd ~/kubeone; kubeone apply -m kubeone.yaml -t tf.json -y
	cd ~/kubeone; terraform apply -auto-approve

.PHONY: teardown
teardown: 
	cd ~/kubeone; kubeone reset --manifest kubeone.yaml -t tf.json -y
	cd ~/kubeone; terraform destroy -auto-approve
