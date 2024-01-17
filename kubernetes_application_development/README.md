# Kubernetes Application Development

## Pre-requisites

> If you do not have Google Cloud Account, instead you are working on your local machine then you can simply skip #1 and #4 steps. Before you get started, please make sure that you have [Minikube installation](https://minikube.sigs.k8s.io/docs/start/) on your local machine.

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com) via web browser.

2. Clone the Kubermatic trainings git repository:

   ```bash
   git clone https://github.com/kubermatic-labs/trainings.git
   ```

3. Navigate to Kubernetes Fundamentals training folder to get started

   ```bash
   cd trainings/kubernetes_application_development/
   ```

4. [Setup](00_setup/README.md) - the GKE cluster for training.

## Hands-On

1. [Config Maps](01_configmaps/README.md)
1. [Secrets](02_secrets/README.md)
1. [Downward API](03_downward_api/README.md)
1. [Probing](04_probing/README.md)
1. [Graceful Shutdown](05_graceful_shutdown/README.md)
1. [OOM (Out of Memory)](06_oom/README.md)
1. [Init Containers](07_init_containers/README.md)
1. [Debug Containers](08_debug_containers/README.md)

## Teardown

[TearDown Setup](99_teardown/README.md) - Optional, for the GKE training cluster cleanup.
