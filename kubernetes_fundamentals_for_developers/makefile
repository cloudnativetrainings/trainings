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

.PHONY get-ingress-ip:
get-ingress-ip:
	gcloud compute addresses list --filter="region:europe-west3"  --filter="name=training-kf-addr" --format="get(address)"

.PHONY teardown:
teardown:
	./teardown.sh
	$(MAKE) -C ../kubernetes_fundamentals/ teardown
