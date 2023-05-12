# Setup

## Install Tooling

### KubeOne

```bash
mkdir -p /tmp/k1 && cd /tmp/k1 && wget https://github.com/kubermatic/kubeone/releases/download/v1.6.2/kubeone_1.6.2_linux_amd64.zip
unzip kubeone*.zip
mkdir -p ~/bin && cp kubeone ~/bin/kubeone
cd ~
```

### Setup Environment

```bash
mkdir -p ~/bin
echo "export TRAINING_DIR=~/trainings/advanced_operations_of_kubernetes_with_kubeone" >> ~/.bashrc
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
  kubectl version --short
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
echo $PROJECT_ID
```

Jump > [**Home**](../README.md) | Next > [**GCE Service Account Setup**](../01_create-cloud-credentials/README.md)