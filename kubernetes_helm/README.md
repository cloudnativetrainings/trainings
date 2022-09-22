# Kubernetes Helm

**Pre-requisites:**

>If you do not have Google Cloud Account, instead you are working on your local machine then you can simply skip #1 and #4 steps. Before you get started, please make sure that you have [Minikube installation](https://minikube.sigs.k8s.io/docs/start/) on your local machine.

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com ) via web browser. 

2. Clone the Kubermatic trainings git repository:
    ```bash
    git clone https://github.com/kubermatic-labs/trainings.git
    ```

3. Navigate to Kubernetes Helm training folder to get started
    ```bash  
    cd trainings/k8s_helm/
    ```

4. [Setup](00_setup/README.md) - the GKE cluster for training.
   
**Hands-On:**

1. [Install Apps without Helm](01_apps-without-helm/README.md)
2. [Install Apps with Helm](02_apps-with-helm/README.md)
3. [Rollback](03_rollback/README.md)
4. [Variables](04_variables/README.md)
5. [Functions](05_functions/README.md)
6. ['include' function](06_includes/README.md)
7. [If Statement](07_ifs/README.md)
8. ['required' function](08_required/README.md)
9. [Helm Test](09_tests/README.md)
10. [Hooks](10_hooks/README.md)
11. [Dependencies](11_dependencies/README.md)

[TearDown Setup](99_teardown/README.md) - Optional, for the GKE training cluster cleanup. 

[Back to Main](../README.md)