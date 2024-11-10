# Setup

## Install Tooling

### Install KubeOne

```bash
export KUBEONE_VERSION=1.8.0
mkdir -p /tmp/k1 && cd /tmp/k1 && \
  wget https://github.com/kubermatic/kubeone/releases/download/v${KUBEONE_VERSION}/kubeone_${KUBEONE_VERSION}_linux_amd64.zip
unzip kubeone_${KUBEONE_VERSION}_linux_amd64.zip
mkdir -p ~/bin && cp kubeone ~/bin/kubeone
cd ~
```

### Setup Training Environment

```bash
export TRAINING_DIR=~/trainings/advanced_operations_of_kubernetes_with_kubeone
echo "export TRAINING_DIR=$TRAINING_DIR" >> ~/.bashrc
echo "export PATH=$PATH:~/bin" >> ~/.bashrc
echo ". <(kubeone completion bash)" >> ~/.bashrc
echo "cd $TRAINING_DIR" >> ~/.bashrc
. ~/.bashrc
```

## Verify setup

After you entered the container, verify the setup:

* List the training folders
  ```bash
  ls -alh
  ```

* Verify the kubeone version, a json with kubeone v1.6.2 should be shown
  ```bash
  kubeone version
  ```

* Verify terraform version, a recent version (>= 1.4.x) should be shown
  ```bash
  terraform version
  ```

* Verify the Google Cloud SDK version, a recent gcloud SDK (>= 428.0.0)
  ```bash
  gcloud version
  ```

* Verify kubectl version, a recent kubectl version (>= v.1.27.1)
  ```bash
  kubectl version
  ```

## Authenticate your GCP account

### Execute the setup script

```bash
./00_setup/setup.sh
```

### List your training projects

```bash
gcloud projects list
```

```text
PROJECT_ID       NAME            PROJECT_NUMBER
student-00-xxx  student-00-xxx   999999999999
```

```bash
echo $GCP_PROJECT_ID
```

> Note you may have to start a new bash terminal tab to engage the changes we made.

Jump > [**Home**](../README.md) | Next > [**GCE Service Account Setup**](../01_create-cloud-credentials/README.md)