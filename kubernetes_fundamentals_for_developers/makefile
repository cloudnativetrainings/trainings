INGRESS_IP_NAME=training-ingress

TRAINING_RC_FILE=~/.trainingrc
.PHONY setup:
setup:
	$(MAKE) -C ../kubernetes_fundamentals/ setup
	./setup.sh
	grep -qxF "source <(helm completion bash)" $(TRAINING_RC_FILE) || echo "source <(helm completion bash)" >> $(TRAINING_RC_FILE)

.PHONY verify:
verify:
	$(MAKE) -C ../kubernetes_fundamentals/ verify
	helm status -n ingress-nginx ingress-nginx
	helm status -n monitoring monitoring
	helm status -n logging logging
	# TODO veriication of ingress needed

.PHONY get-ingress-ip:
get-ingress-ip:
	gcloud compute addresses list --filter="name=$(INGRESS_IP_NAME)" --format="get(address)"

.PHONY teardown:
teardown:
	./teardown.sh
	$(MAKE) -C ../kubernetes_fundamentals/ teardown
