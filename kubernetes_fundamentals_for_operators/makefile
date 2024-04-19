TRAINING_RC_FILE=~/.trainingrc

.PHONY setup:
setup:
	grep -qxF "source $(TRAINING_RC_FILE)" ~/.bashrc || echo "source $(TRAINING_RC_FILE)" >> ~/.bashrc
	./setup_gcp_params.sh
	go install github.com/cloudflare/cfssl/cmd/{cfssl,cfssljson}@v1.6.5

.PHONY verify:
verify:
	cfssl version
	cfssljson --version

.PHONY teardown:
teardown:
	./teardown.sh