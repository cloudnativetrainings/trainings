.PHONY: destroy
destroy:
	cd ~/kubeone; kubeone reset --manifest kubeone.yaml -t tf.json -y
	cd ~/kubeone; terraform destroy -auto-approve
	sudo rm -rf ~/*

# manual deletes
# * vpc network
# * service account
# * dns entries
