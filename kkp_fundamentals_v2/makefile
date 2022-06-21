.PHONY: destroy
destroy:
	cd ~/master/kubeone; kubeone reset --manifest kubeone.yaml -t tf.json -y
	cd ~/master/kubeone; terraform destroy -auto-approve
	cd ~/seed/kubeone; kubeone reset --manifest kubeone.yaml -t tf.json -y
	cd ~/seed/kubeone; terraform destroy -auto-approve
	rm -rf /tmp/kubeone
	rm -rf /tmp/kkp
	rm -rf ~/master
	rm -rf ~/seed
	rm -rf ~/trainings
	rm -rf ~/key.json
	rm -rf ~/.ssh
