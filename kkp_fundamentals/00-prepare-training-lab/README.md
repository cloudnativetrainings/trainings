# Prepare training lab

## Prerequisites

To complete this lab successfully, you are expected to have:

- Basic understanding of Kubernetes architecture, API objects, and essential commands.
- Basic infrastructure knowledge on networking, DNS, and resources provisioning.
- Internet Access to GitHub, Google Cloud, Terraform registry, and Quay.io.
- Latest Docker installed.
- Git client
- Text editor (preferably one with Kubernetes support e.g. [VSCode](https://code.visualstudio.com/) or [Intellij Plugin](https://plugins.jetbrains.com/plugin/10485-kubernetes/versions)).

## Environment setup

> 💡 Tip: Use [Google Cloud Shell](https://shell.cloud.google.com/) for a ready-to-use and fast environment.

For a quick start, we will use the [KubeOne Tooling container](https://github.com/kubermatic/community-components/tree/master/helper/kubeone-tool-container) container, which has the necessary tools already installed.

```bash
git clone https://github.com/kubermatic-labs/trainings.git
docker run --name kubeone-tool-container -v $(pwd)/trainings:/home/kubermatic/trainings -t -d quay.io/kubermatic-labs/kubeone-tooling:1.2.3
docker exec -it kubeone-tool-container bash
```
The lab runs in the container's shell.

## Verifying setup

Verify that you have all the tools necessary running correctly by executing the following **in the container's shell**:

```bash
export TRAINING_DIR=`pwd`/trainings/kkp_fundamentals
cd $TRAINING_DIR

#### List training folders
ls -la

#### KubeOne version v1.2.3
kubeone version

#### Terraform version (>= 0.15)
terraform version

#### Google Cloud SDK (>= 340.0.0)
gcloud version

#### kubectl version (>= v.1.21.1)
kubectl version --short --client
```

## Authorize Google Cloud SDK tools

Execute the setup script:

```bash
./00-prepare-training-lab/setup.sh
```

Which grants access to Cloud SDK to access Google Cloud resources.

Verify the authorization is successful by listing your projects:

```bash
gcloud projects list
```
Output:
```text
PROJECT_ID        NAME              PROJECT_NUMBER
student-XX-xxxx   student-XX-xxxx   999999999999
```

## Useful links

The most needed shortcuts and tooling helper are already installed in the tooling container, however, you can take a loot at the [helpful-commands.md](helpful-commands.md) section to know how to configure auto-completion for example or install [fubectl](https://github.com/kubermatic/fubectl) for fast Kubernetes navigation.

If you don't like to use the KubeOne tooling container and install all tools directly locally, you can take a look at the [KubeOne tooling container dockerfile](https://github.com/kubermatic/community-components/blob/master/helper/kubeone-tool-container/Dockerfile).

## Help and support

As an opensource driven company, Kubermatic contributes a lot of helpful components or information to the community, so feel free to take a look at these resources:

- [Official Documentation](https://docs.kubermatic.com/)
- [Kubermatic Community Components](https://github.com/kubermatic/community-components)
- [Kubermatic Forum](https://forum.kubermatic.com/)
