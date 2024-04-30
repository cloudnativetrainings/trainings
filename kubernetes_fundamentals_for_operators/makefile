export ETCD_VERSION=3.5.8
export KUBERNETES_VERSION=1.28.9
export RUNC_VERSION=1.1.12
export CONTAINERD_VERSION=1.7.16
export CRICTL_VERSION=1.30.0
export CNI_PLUGINS_VERSION=1.4.1

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