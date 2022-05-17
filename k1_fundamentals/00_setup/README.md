# KubeOne Training

## Prerequisites
Prerequisites what need to be fulfilled by the attendees of the trainings:

- Common understanding of Kubernetes architecture, API objects and principles
- Basic compute infrastructure knowledge about networking, DNS and resource provisioning
- Internet Access to GitHub, GoogleCloud, terraform provider, quay.io
- Latest Docker Installed
- git client- IDE / Editor
  (preferred with Kubernetes support e.g. [VSCode](https://code.visualstudio.com/) or [Intellij Plugin](https://plugins.jetbrains.com/plugin/10485-kubernetes/versions))

## Setup Tooling Container

To speed up, the setup we will use the container, where every need tool is already setup.

If you have docker, git and a common IDE installed locally, you can quickly start with:

```bash
git clone https://github.com/kubermatic-labs/trainings.git
docker run --name kubeone-tool-container -v $(pwd):/home/kubermatic/mnt -t -d quay.io/kubermatic-labs/kubeone-tooling:1.4.2
```
Connect into the running container and ensures that you can reattach if you get kicked out of the container:

```bash
docker exec -it kubeone-tool-container bash
```

**Alternative** - If you prefer a temporary container only (get removed after you leave it) execute:

```bash
# remove old container
docker rm -f kubeone-tool-container

docker run --rm --name kubeone-tool-container -v $(pwd):/home/kubermatic/mnt -it quay.io/kubermatic-labs/kubeone-tooling:1.4.2 bash
```

### (Alternative) Use Google Cloud Shell

Open the [Google Cloud Shell](https://shell.cloud.google.com) in a separate window.

Now execute the above commands.

## Verify setup

After you entered the container, verify the setup:

* Set the training directory path inside the container.
  ```bash
  export TRAINING_DIR=`pwd`/mnt/trainings/k1_fundamentals
  cd $TRAINING_DIR
  ```

* List the training folders
  ```bash
  ls -la
  ```

* Verify the kubeone version, a json with kubeone v1.4.2 should be shown
  ```bash
  kubeone version
  ```

* Verify terraform version, a recent version (>= 1.1.x) should be shown
  ```bash
  terraform version
  ```

* Verify teh Google Cloud SDK version, a recent gcloud SDK (>= 384.0.0)
  ```bash
  gcloud version
  ```

* Verify kubectl version, a recent kubectl version (>= v.1.22.0)
  ```bash
  kubectl version --short
  ```

## Authenticate your GCP account

Execute the setup script.
```bash
./00_setup/setup.sh
```

List your training projects
```bash
gcloud projects list
```

```text
PROJECT_ID       NAME            PROJECT_NUMBER
student-00-xxx  student-00-xxx   999999999999
```

## Other helpful content

The most needed shortcuts and tooling helper are already installed in the tooling container, anyway you could look over the [helpful commands](helpful_commands.md) section, to read how e.g. install auto-completion and [fubectl](https://github.com/kubermatic/fubectl) for fast Kubernetes navigation.

If you don't like to use the KubeOne tooling container and install all tools directly locally, you can take a look at:
- [local_install_needed_tools.md](local_install_needed_tools.md)
- [KubeOne Tooling Container - Dockerfile](https://github.com/kubermatic/community-components/blob/master/helper/kubeone-tool-container/Dockerfile)

As an opensource driven company, Kubermatic tries to contribute also a lot of helpful components, helper or information to the community, so feel free to take a look at the recent resources:
- [Official Documentation](https://docs.kubermatic.com/)
- [Kubermatic Community Components](https://github.com/kubermatic/community-components)
- [Kubermatic Forum](https://forum.kubermatic.com/)

Jump > [**Home**](../README.md) | Next > [**GCE Service Account Setup**](../01_create-cloud-credentials/README.md)