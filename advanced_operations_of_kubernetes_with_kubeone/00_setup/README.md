# Setup

## Install Tooling

### Run KubeOne Tooling Container

Kubermatic provides a container image which consists of all necessary tools to deploy KubeOne [here](https://quay.io/repository/kubermatic-labs/kubeone-tooling?tab=tags)

```bash
# clone trainings repo
git clone https://github.com/cloudnativetrainings/trainings.git

# start the tooling container
export KUBEONE_VERSION=1.9.2
docker run -d -it --network host -v $HOME/trainings/advanced_operations_of_kubernetes_with_kubeone:/home/kubermatic/training --name kubeone-tooling-${KUBEONE_VERSION} quay.io/kubermatic-labs/kubeone-tooling:${KUBEONE_VERSION}

# start a shell in the container
docker exec -it kubeone-tooling-${KUBEONE_VERSION} bash
```

### Setup Training Environment

```bash
export TRAINING_DIR=~/training
echo "export TRAINING_DIR=$TRAINING_DIR" >> $TRAINING_DIR/.trainingrc
echo "cd $TRAINING_DIR" >> $TRAINING_DIR/.trainingrc
. $TRAINING_DIR/.trainingrc
```

<details>
<summary>Without the tooling container</summary>

### Install Tooling

You can also run this on your Linux box (you need to )

```bash
export KUBEONE_VERSION=1.9.2
mkdir -p /tmp/k1 && cd /tmp/k1 && \
  wget https://github.com/kubermatic/kubeone/releases/download/v${KUBEONE_VERSION}/kubeone_${KUBEONE_VERSION}_linux_amd64.zip
unzip kubeone_${KUBEONE_VERSION}_linux_amd64.zip
mkdir -p ~/bin && cp kubeone ~/bin/kubeone
cd ~
```

### Setup Training Environment

```bash
git clone https://github.com/cloudnativetrainings/trainings.git
export TRAINING_DIR=~/trainings/advanced_operations_of_kubernetes_with_kubeone
echo "export TRAINING_DIR=$TRAINING_DIR" >> $TRAINING_DIR/.trainingrc
echo "export PATH=$PATH:~/bin" >> $TRAINING_DIR/.trainingrc
echo ". <(kubeone completion bash)" >> $TRAINING_DIR/.trainingrc
echo "cd $TRAINING_DIR" >> $TRAINING_DIR/.trainingrc
. $TRAINING_DIR/.trainingrc
```
</details>

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
source $TRAINING_DIR/.trainingrc
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