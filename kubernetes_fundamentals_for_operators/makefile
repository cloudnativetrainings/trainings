.PHONY setup:
setup:
	./setup_trainingrc_file.sh
	./setup_trainingrc_file_nodes.sh
	go install github.com/cloudflare/cfssl/cmd/{cfssl,cfssljson}@v1.6.5

.PHONY verify:
verify:
	cfssl version
	cfssljson --version

.PHONY teardown:
teardown:
	./teardown.sh
	rm -rf secrets/*.pem
	rm -rf secrets/*.csr
	rm -rf secrets/*.kubeconfig
	rm -rf secrets/*.yaml
	rm -rf bin/
