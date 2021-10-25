
## Install / Verify needed Kubernetes and KubeOne tools

### KubeOne

Install the latest version of KubeOne (go needs to be installed or visit and download the binaries here: [KubeOne/releases](https://github.com/kubermatic/kubeone/releases))

```bash
mkdir /tmp/k1 && cd /tmp/k1 && wget https://github.com/kubermatic/kubeone/releases/download/v1.3.0/kubeone_1.3.0_linux_amd64.zip
unzip kubeone*.zip
cp kubeone ~/bin/kubeone
cd ~
```

Verify your installed version

```bash
kubeone version
```

Add bash completion

```bash
echo 'source <(kubeone completion bash)' >> ~/.bashrc && source ~/.bashrc
```

[optional] Create a local copy of the KubeOne CLI documentation. The folder contains the docs for the `kubeone` command line tool. Additional useful documentation can be found under [KubeOne - docs](https://docs.kubermatic.com/kubeone/master/). 

```bash
mkdir kubeone-cli-doc
kubeone document md --output-dir ./kubeone-cli-doc
```

### Terraform

Install Terraform >= 1.0.x (visit [www.terraform.io](https://www.terraform.io/downloads.html) with an SSH setup in place (preferred SSH agent), for more details see [How KubeOne uses SSH](https://docs.kubermatic.com/kubeone/master/using_kubeone/ssh/).

### GCP `gcloud` CLI

For GCP install the latest Google SDK with [`gcloud`](https://cloud.google.com/sdk/install) CLI.
