TRAINING_RC_FILE=~/.trainingrc

.PHONY create-cluster:
create-cluster:
	00_setup/setup_cluster.sh

.PHONY setup:
setup: create-cluster
	grep -qxF "source <(kubectl completion bash)" $(TRAINING_RC_FILE) || echo "source <(kubectl completion bash)" >> $(TRAINING_RC_FILE)
	grep -qxF "source $(TRAINING_RC_FILE)" ~/.bashrc || echo "source $(TRAINING_RC_FILE)" >> ~/.bashrc

POD_NAME=test-pod
.PHONY verify:
verify:
	kubectl delete pod $(POD_NAME) --ignore-not-found=true
	kubectl run $(POD_NAME) --image=nginx 
	kubectl wait --for=condition=Ready pod/$(POD_NAME)
	kubectl delete pod $(POD_NAME)

.PHONY teardown-cluster:
teardown-cluster:
	99_teardown/teardown_cluster.sh

.PHONY teardown:
teardown: teardown-cluster
	> $(TRAINING_RC_FILE)
