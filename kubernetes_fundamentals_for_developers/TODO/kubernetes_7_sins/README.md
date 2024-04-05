# The 7 Deadly Sins in Kubernetes

## Pre-requisites

> If you do not have Google Cloud Account, instead you are working on your local machine then you can simply skip #1 and #4 steps. Before you get started, please make sure that you have [Minikube installation](https://minikube.sigs.k8s.io/docs/start/) on your local machine.

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com) via web browser.

2. Clone the Kubermatic trainings git repository:

   ```bash
   git clone https://github.com/kubermatic-labs/trainings.git
   ```

3. Navigate to Kubernetes Fundamentals training folder to get started

   ```bash
   cd trainings/kubernetes_7_sins/
   ```

4. [Setup](00_setup/README.md) - the GKE cluster for training.

## Hands-On

1. [Resource Requests and Limits](01_oom/README.md)
1. [Graceful Shutdown](02_1_graceful_shutdown/README.md)
1. [Dragons](02_2_dragons/README.md)
1. [Probing](03_probing/README.md)
1. [Scaling](04_scaling/README.md)
1. [No Restarts](06_no_restart/README.md)

## Teardown

[TearDown Setup](99_teardown/README.md) - Optional, for the GKE training cluster cleanup.
