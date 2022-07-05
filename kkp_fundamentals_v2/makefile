.PHONY: destroy
destroy:
	cd ~/kubeone; kubeone reset --manifest kubeone.yaml -t tf.json -y
	cd ~/kubeone; terraform destroy -auto-approve
	sudo rm -rf ~/*
	# TODO issue with networks terraform destroy
	# │ Error: Error waiting for Deleting Network: The network resource 'projects/student-00-kkp-admin-training/global/networks/master' is already being used by 'projects/student-00-kkp-admin-training/global/routes/master-21959b73-0fd5-455a-8826-9f49ce4cb7da'
	# TODO delete the serviceaccount


# https://stackoverflow.com/questions/2670130/make-how-to-continue-after-a-command-fails

#  make -k

# manual deletes
# * vpc network
# * service account
# * dns entry ?!?!?!
