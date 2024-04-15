INGRESS_IP_NAME=training-ingress
TRAINING_RC_FILE=~/.trainingrc

INGRESS_IP=$(shell gcloud compute addresses list --filter="name=$(INGRESS_IP_NAME)" --format="get(address)")
.PHONY setup:
setup:
	$(MAKE) -C ../kubernetes_fundamentals/ setup
	./setup.sh
	grep -qxF "source <(helm completion bash)" $(TRAINING_RC_FILE) || echo "source <(helm completion bash)" >> $(TRAINING_RC_FILE)
	grep -qxF "export INGRESS_IP=" $(TRAINING_RC_FILE) || echo "export INGRESS_IP=$(INGRESS_IP)" >> $(TRAINING_RC_FILE)

POD_NAME=test-pod
INGRESS_IP=$(shell gcloud compute addresses list --filter="name=$(INGRESS_IP_NAME)" --format="get(address)")
.PHONY verify:
verify:
	kubectl delete pod $(POD_NAME) --ignore-not-found=true
	kubectl run $(POD_NAME) --image=quay.io/kubermatic-labs/training-application:2.0.0 
	kubectl wait --for=condition=Ready pod/$(POD_NAME)
	kubectl delete pod $(POD_NAME)
	test -n "$(INGRESS_IP)"
	helm status -n ingress-nginx ingress-nginx
	helm status -n monitoring monitoring
	helm status -n logging logging
	curl -I http://$(INGRESS_IP):80
	helm status -n vault vault

.PHONY get-ingress-ip:
get-ingress-ip:
	gcloud compute addresses list --filter="name=$(INGRESS_IP_NAME)" --format="get(address)"

.PHONY teardown:
teardown:
	./teardown.sh
	$(MAKE) -C ../kubernetes_fundamentals/ teardown
