.PHONY create-cluster:
create-cluster:
	00_setup/setup_cluster.sh

.PHONY verify-cluster:
verify-cluster:
	kubectl get nodes -o json | jq -r .items | jq length == 2

.PHONY teardown-cluster:
teardown-cluster:
	99_teardown/teardown_cluster.sh
