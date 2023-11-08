# Kubernetes Helm

**Pre-requisites:**

>If you do not have Google Cloud Account, instead you are working on your local machine then you can simply skip #1 and #4 steps. Before you get started, please make sure that you have [Minikube installation](https://minikube.sigs.k8s.io/docs/start/) on your local machine.

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com ) via web browser. 

2. Configure some settings:
    ```bash
    echo "-w \"\\n\"" > $HOME/.curlrc

    cat <<EOT > $HOME/.vimrc
    set expandtab
    set tabstop=2
    set shiftwidth=2
    EOT

    sudo apt-get update && sudo apt-get -y install tree bat
    ```

3. Create `.customize_environment` file to make sure tree and batcat will always be installed with new Cloud Shell instances
    ```bash
    cp customize_environment.sh $HOME/.customize_environment
    ```

4. Clone the Kubermatic trainings git repository:
    ```bash
    git clone https://github.com/kubermatic-labs/trainings.git
    ```

5. Navigate to Kubernetes Helm training folder to get started
    ```bash  
    cd trainings/kubernetes_helm/
    ```

6. [Setup](00_setup/README.md) - the GKE cluster for training.
   
**Hands-On:**

1. [Install Apps with Manifests](01_apps-with-only-manifests/README.md)
2. [Deploy with Kustomize](02_deploy-with-kustomize/README.md)
3. [Install Apps with Helm](02_apps-with-helm/README.md)
4. [Rollback](03_rollback/README.md)
5. [Variables](04_variables/README.md)
6. [Functions](05_functions/README.md)
7. ['include' function](06_includes/README.md)
8. [If Statement](07_ifs/README.md)
9. ['required' function](08_required/README.md)
10. [Helm Test](09_tests/README.md)
11. [Hooks](10_hooks/README.md)
12. [Dependencies](11_dependencies/README.md)

[TearDown Setup](99_teardown/README.md) - Optional, for the GKE training cluster cleanup. 

[Back to Main](../README.md)