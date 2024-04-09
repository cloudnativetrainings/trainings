.PHONY setup:
setup:
	$(MAKE) -C ../kubernetes_fundamentals/ setup
	./setup.sh
	# ingress
	# prom
	# loki
	# grep -qxF "source <(helm completion bash)" $(TRAINING_RC_FILE) || echo "source <(helm completion bash)" >> $(TRAINING_RC_FILE)

.PHONY verify:
verify:
	$(MAKE) -C ../kubernetes_fundamentals/ verify
	# ingress
	# prom
	# loki

.PHONY teardown:
teardown:
	./teardown.sh
	$(MAKE) -C ../kubernetes_fundamentals/ teardown
